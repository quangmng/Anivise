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
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false

    func signIn() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isLoggedIn = true
                }
            }
        }
    }

    func signInWithGoogle() {
        isLoading = true
        Task {
            do {
                try await Authentication().googleOauth()
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.isLoggedIn = true
                }
            } catch AuthenticationError.runtimeError(let errorMessage) {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.errorMessage = errorMessage
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
