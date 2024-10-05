//
//  PasswordlessLoginView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//


import SwiftUI

struct PasswordlessLoginView: View {
    @StateObject private var viewModel = PasswordlessLoginViewModel()

    var body: some View {
        VStack {
            TextField("Enter your email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if viewModel.isLinkSent {
                Text("A sign-in link has been sent to your email.")
                    .foregroundColor(.green)
                    .padding()
            } else {
                Button(action: viewModel.sendSignInLink) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Send Sign-In Link")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    PasswordlessLoginView()
}
