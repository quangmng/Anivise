//
//  OnboardingView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 12/10/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection = 0
    @State private var showGenreSelection = false
    
    var body: some View {
        ZStack {
            // TabView for multiple onboarding steps
            TabView(selection: $selection) {
                // Step 1
                OnboardingStepView(title: "Discover", description: "Explore a world of anime tailored to your preferences!")
                    .tag(0)
                    .background(selection == 0 ? Color("discoverTab") : Color.clear)
                
                // Step 2
                OnboardingStepView(title: "Track", description: "Keep track of your favorite shows and movies.")
                    .tag(1)
                    .background(selection == 1 ? Color("trackTab") : Color.clear)
                
                // Step 3
                OnboardingStepView(title: "Recommend", description: "Receive recommendations based on your taste!")
                    .tag(2)
                    .background(selection == 2 ? Color("recommendTab") : Color.clear)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .background(selection == 0 ? Color("discoverTab") :
                        selection == 1 ? Color("trackTab") :
                        selection == 2 ? Color("recommendTab") : Color.clear)
            .edgesIgnoringSafeArea(.all)
            
            // Show "Get Started" button on the last page (Step 3)
            if selection == 2 {
                VStack {
                    Spacer()
                    Button(action: {
                        showGenreSelection.toggle()
                    }) {
                        Text("Get Started")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(25)
                    }
                    .padding()
                    .fullScreenCover(isPresented: $showGenreSelection, content: {
                        GenreSelectView()
                    })
                }
            }
        }
    }
}

struct OnboardingStepView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            if title == "Discover" {
                if #available(iOS 18.0, *) {
                    Image(systemName: "film.stack.fill")
                        .symbolEffect(.bounce.up.byLayer, options: .nonRepeating)
                        .font(.system(size: 50))
                } else {
                    // Fallback on earlier versions
                    Image(systemName: "film.stack.fill")
                        .font(.system(size: 50))
                }
            } else if title == "Track" {
                Text("✍️")
                    .font(.system(size: 50))
            } else if title == "Recommend" {
                Text("🤗")
                    .font(.system(size: 50))
            }
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}
