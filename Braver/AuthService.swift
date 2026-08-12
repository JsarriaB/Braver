import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseAppCheck
import GoogleSignIn
import AuthenticationServices
import CryptoKit

@Observable
final class AuthService: NSObject {

    static let shared = AuthService()

    var userId: String? { Auth.auth().currentUser?.uid }
    var isSignedIn: Bool { Auth.auth().currentUser != nil }
    var isAnonymous: Bool { Auth.auth().currentUser?.isAnonymous ?? true }
    var linkedProviderIDs: [String] {
        Auth.auth().currentUser?.providerData.map { $0.providerID } ?? []
    }

    private var currentNonce: String?
    private var appleAuthContinuation: CheckedContinuation<(credential: OAuthCredential, authorizationCode: String), Error>?

    private override init() {
        super.init()
    }

    // MARK: - Anónimo (se llama al abrir la app por primera vez)

    func signInAnonymouslyIfNeeded() async {
        guard Auth.auth().currentUser == nil else { return }
        do {
            try await Auth.auth().signInAnonymously()
        } catch {
            print("[Auth] Error login anónimo: \(error)")
        }
    }

    // MARK: - Sign in with Apple

    func linkWithApple() async throws {
        let result = try await performAppleAuthorization()
        if let user = Auth.auth().currentUser, user.isAnonymous {
            try await user.link(with: result.credential)
        } else {
            try await Auth.auth().signIn(with: result.credential)
        }
    }

    /// Reautentica con Apple (requisito de Firebase para operaciones sensibles como borrar la
    /// cuenta) y devuelve el `authorizationCode` fresco de esa misma solicitud, necesario para
    /// revocar el acceso de Apple por separado con `Auth.auth().revokeToken(withAuthorizationCode:)`.
    @discardableResult
    func reauthenticateWithApple() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Auth", code: -4, userInfo: [NSLocalizedDescriptionKey: "No hay sesión activa"])
        }
        let result = try await performAppleAuthorization()
        try await user.reauthenticate(with: result.credential)
        return result.authorizationCode
    }

    private func performAppleAuthorization() async throws -> (credential: OAuthCredential, authorizationCode: String) {
        try await withCheckedThrowingContinuation { continuation in
            self.appleAuthContinuation = continuation
            let nonce = randomNonce()
            self.currentNonce = nonce
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    // MARK: - Email + contraseña

    func linkWithEmail(email: String, password: String) async throws {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let user = Auth.auth().currentUser, user.isAnonymous {
            try await user.link(with: credential)
        } else {
            try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }

    func signInWithEmail(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    /// Reautentica con contraseña (requisito de Firebase para operaciones sensibles).
    func reauthenticateWithPassword(_ password: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NSError(domain: "Auth", code: -5, userInfo: [NSLocalizedDescriptionKey: "No hay email asociado a la cuenta"])
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await user.reauthenticate(with: credential)
    }

    func signInWithGoogle() async throws {
        let credential = try await googleCredential()
        if let user = Auth.auth().currentUser, user.isAnonymous {
            try await user.link(with: credential)
        } else {
            try await Auth.auth().signIn(with: credential)
        }
    }

    /// Reautentica con Google (requisito de Firebase para operaciones sensibles).
    func reauthenticateWithGoogle() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Auth", code: -4, userInfo: [NSLocalizedDescriptionKey: "No hay sesión activa"])
        }
        let credential = try await googleCredential()
        try await user.reauthenticate(with: credential)
    }

    private func googleCredential() async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "Auth", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing Google clientID in GoogleService-Info.plist"])
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        guard let windowScene = await UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootVC = await windowScene.keyWindow?.rootViewController else {
            throw NSError(domain: "Auth", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "No root view controller"])
        }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "Auth", code: -3,
                          userInfo: [NSLocalizedDescriptionKey: "No ID token from Google"])
        }
        return GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Borrado de cuenta

    enum AccountDeletionError: LocalizedError {
        case noActiveSession
        case serverFailed(String)

        var errorDescription: String? {
            switch self {
            case .noActiveSession: return "No hay una sesión activa."
            case .serverFailed(let message): return message
            }
        }
    }

    /// Borra la cuenta y todos los datos del usuario en el servidor (Firestore + Firebase Auth).
    /// No borra nada local — el llamador debe limpiar SwiftData/UserDefaults solo si esta función
    /// termina sin lanzar error.
    func deleteAccountOnServer() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AccountDeletionError.noActiveSession
        }

        // 1. Reautenticación reciente — requisito de Firebase para operaciones sensibles.
        //    Sin proveedor vinculado (cuenta puramente anónima) no hay identidad real que
        //    suplantar, así que no hace falta reautenticar.
        if linkedProviderIDs.contains("google.com") {
            try await reauthenticateWithGoogle()
        } else if linkedProviderIDs.contains("apple.com") {
            let appleAuthorizationCode = try await reauthenticateWithApple()
            // Revoca el acceso de Apple — requiere el "OAuth code flow" configurado en
            // Firebase Console → Authentication → Sign-in method → Apple (Services ID,
            // Team ID, Key ID y clave privada .p8), ya confirmado por el usuario.
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                Auth.auth().revokeToken(withAuthorizationCode: appleAuthorizationCode) { error in
                    if let error { continuation.resume(throwing: error) } else { continuation.resume() }
                }
            }
        } else if linkedProviderIDs.contains("password") {
            // No hay UI que use email/contraseña hoy, pero se deja el hook por si se añade.
        }

        // 2. ID token fresco (con auth_time actualizado tras la reautenticación anterior).
        let idToken = try await user.getIDToken(forcingRefresh: true)

        // 3. Cloud Function: verifica el token + auth_time, borra Firestore y Firebase Auth.
        var request = URLRequest(url: URL(string: "https://us-central1-braver-4d2bc.cloudfunctions.net/deleteAccount")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        let appCheckToken = try await AppCheck.appCheck().token(forcingRefresh: false)
        request.setValue(appCheckToken.token, forHTTPHeaderField: "X-Firebase-AppCheck")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let serverMessage = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String
            throw AccountDeletionError.serverFailed(serverMessage ?? "El servidor no pudo completar el borrado.")
        }
    }

    // MARK: - Helpers criptográficos

    private func randomNonce(length: Int = 32) -> String {
        var bytes = [UInt8](repeating: 0, count: length)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return bytes.map { String(format: "%02x", $0) }.joined()
    }

    private func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = currentNonce,
            let tokenData = appleIDCredential.identityToken,
            let token = String(data: tokenData, encoding: .utf8),
            let authCodeData = appleIDCredential.authorizationCode,
            let authorizationCode = String(data: authCodeData, encoding: .utf8)
        else {
            appleAuthContinuation?.resume(throwing: NSError(domain: "Auth", code: -1))
            return
        }
        let credential = OAuthProvider.appleCredential(withIDToken: token,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        appleAuthContinuation?.resume(returning: (credential: credential, authorizationCode: authorizationCode))
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        appleAuthContinuation?.resume(throwing: error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
