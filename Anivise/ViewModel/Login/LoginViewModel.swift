//
//  LoginViewModel.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var err: String?
    @Published var isLoggedIn: Bool = false

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.err = error.localizedDescription
            } else {
                self?.isLoggedIn = true
            }
        }
    }
    func signInWithGoogle() {
        Task {
            do {
                try await Authentication().googleOauth()
            } catch AuthenticationError.runtimeError(let errorMessage) {
                err = errorMessage
            }
        }
    }
}
