//
//  ProfileView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 6/10/2024.
//

import SwiftUI
import FirebaseAuth



struct ProfileView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @State private var showLogin = false
    @State private var userEmail: String? = Auth.auth().currentUser?.email
    @State private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome to Test Auth!")
                    .font(.headline)
                    .padding()

                if userLoggedIn {
                    // Display the user's email
                    if let email = userEmail {
                        Text("Hello, \(email)!")
                            .font(.subheadline)
                            .padding()
                    }

                    // Sign Out button
                    Button(action: {
                        signOut()
                    }) {
                        Text("Sign Out")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    // Sign In button
                    Button {
                        showLogin.toggle()
                    } label: {
                        Text("Sign In")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showLogin) {
                        NavigationStack {
                            LoginView()
                                .navigationTitle("Sign In")
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            showLogin = false
                                        }) {
                                            CloseButton().frame(width: 24, height: 24)
                                        }
                                    }
                                }
                        }
                        
                        .presentationDetents([.height(550), .large])
                    }
                }
            }
        }
        .onAppear {
            // Firebase state change listener
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    userLoggedIn = true
                    userEmail = user.email
                    showLogin = false // Automatically dismiss the "Sign In" sheet
                } else {
                    userLoggedIn = false
                    userEmail = nil
                }
            }
        }
        .onDisappear {
            // Remove the state listener if necessary
            if let handle = authStateDidChangeListenerHandle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }

    // Sign out method
    private func signOut() {
        do {
            try Auth.auth().signOut()
            userLoggedIn = false
            userEmail = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}


#Preview {
    ProfileView()
}
