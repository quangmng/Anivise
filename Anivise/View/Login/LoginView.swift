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
            if viewModel.isLoading {
                ProgressView("Signing in...")
                    .padding()
            } else {
                // Email and password fields
                TextField("Enter your email", text: $viewModel.email)
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                
                
                SecureField("Enter your password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Traditional email-password login button
                    .padding(.bottom, 8)
                Button(){
                    viewModel.signIn()
                } label: {
                        Image(systemName: "person.fill")
                        Text("Sign in")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 8)
                
                Text("OR")
                
                // Google sign-in button
                Button() {
                    viewModel.signInWithGoogle()
                } label: {

                        Image("gIconSmol")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Google")
                        .foregroundStyle(.gLoginTxt)
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.gLoginBtn)
            }
        }
        .padding()
        // Display error message, if any
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Sign In Failed"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.errorMessage = nil
                    })
                )
        }
    }
}

#Preview {
    LoginView()
}
