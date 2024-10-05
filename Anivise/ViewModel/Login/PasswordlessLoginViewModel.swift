//
//  PasswordlessLoginViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import Foundation
import FirebaseAuth

class PasswordlessLoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var isLinkSent: Bool = false

    func sendSignInLink() {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com/complete-signin") // Your redirect URL
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            // Save email locally for later verification
            UserDefaults.standard.set(self?.email, forKey: "EmailForSignIn")
            self?.isLinkSent = true
        }
    }

    func verifySignInLink(_ link: URL, completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "EmailForSignIn") else {
            completion(false)
            return
        }

        Auth.auth().signIn(withEmail: email, link: link.absoluteString) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            // Successful sign-in
            completion(true)
        }
    }
}
