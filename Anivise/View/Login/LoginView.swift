//
//  LoginView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            // Email and password fields
            TextField("Enter your email", text: $viewModel.email)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
               

            SecureField("Enter your password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Traditional email-password login button
            Button(action: viewModel.signIn) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Sign in")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Text("OR")

            // Google sign-in button
            Button(action: viewModel.signInWithGoogle) {
                HStack {
                    Image("gIconSmol")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("Sign in with Google")
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            // Display error message, if any
            if let errorMessage = viewModel.err {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
