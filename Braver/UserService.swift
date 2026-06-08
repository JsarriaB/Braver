import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
final class UserService {

    static let shared = UserService()

    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Perfil

    func createOrUpdateProfile(name: String?, age: String?) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var data: [String: Any] = [
            "updatedAt": FieldValue.serverTimestamp()
        ]
        if let name, !name.isEmpty { data["name"] = name }
        if let age, !age.isEmpty { data["age"] = age }
        if Auth.auth().currentUser?.isAnonymous == false {
            data["createdAt"] = FieldValue.serverTimestamp()
        }
        try? await db.collection("users").document(uid).setData(data, merge: true)
    }

    func markOnboardingComplete() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try? await db.collection("users").document(uid).setData(
            ["onboardingCompleted": true, "updatedAt": FieldValue.serverTimestamp()],
            merge: true
        )
    }

    // MARK: - Suscripción

    func fetchSubscriptionStatus() async -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let doc = try? await db.collection("users").document(uid)
            .collection("subscription").document("current").getDocument(),
              doc.exists else { return false }
        let status = doc.data()?["status"] as? String
        let expiresAt = (doc.data()?["expiresAt"] as? Timestamp)?.dateValue()
        if status == "active" {
            if let expires = expiresAt { return expires > Date() }
            return true
        }
        return false
    }
}
