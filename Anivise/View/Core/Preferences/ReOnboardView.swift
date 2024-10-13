//
//  ReOnboardView.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 12/10/2024.
//

import SwiftUI

struct ReOnboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selection = 0
    var body: some View {
        ZStack {
            // TabView for multiple onboarding steps
            TabView(selection: $selection) {
                // Step 1
                OnboardingStepView(title: "Discover", description: "Explore a world of anime tailored to your preferences!")
                    .tag(0)
                
                // Step 2
                OnboardingStepView(title: "Track", description: "Keep track of your favorite shows and movies.")
                    .tag(1)
                
                // Step 3
                OnboardingStepView(title: "Recommend", description: "Receive recommendations based on your taste!")
                    .tag(2)
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
                        // Dismiss the view altogether
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Get Started")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(25)
                    }
                    .padding()
                }
            }
        }
    }
}


#Preview {
    ReOnboardView()
}
