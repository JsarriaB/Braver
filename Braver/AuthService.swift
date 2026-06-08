import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit

@Observable
final class AuthService: NSObject {

    static let shared = AuthService()

    var userId: String? { Auth.auth().currentUser?.uid }
    var isSignedIn: Bool { Auth.auth().currentUser != nil }
    var isAnonymous: Bool { Auth.auth().currentUser?.isAnonymous ?? true }

    private var currentNonce: String?
    private var appleSignInContinuation: CheckedContinuation<Void, Error>?

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
        try await withCheckedThrowingContinuation { continuation in
            self.appleSignInContinuation = continuation
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

    func signInWithGoogle() async throws {
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
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        if let user = Auth.auth().currentUser, user.isAnonymous {
            try await user.link(with: credential)
        } else {
            try await Auth.auth().signIn(with: credential)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
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
            let token = String(data: tokenData, encoding: .utf8)
        else {
            appleSignInContinuation?.resume(throwing: NSError(domain: "Auth", code: -1))
            return
        }
        let credential = OAuthProvider.appleCredential(withIDToken: token,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        Task {
            do {
                if let user = Auth.auth().currentUser, user.isAnonymous {
                    try await user.link(with: credential)
                } else {
                    try await Auth.auth().signIn(with: credential)
                }
                appleSignInContinuation?.resume()
            } catch {
                appleSignInContinuation?.resume(throwing: error)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        appleSignInContinuation?.resume(throwing: error)
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
