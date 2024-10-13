//
//  StartSwipingButton.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 13/10/2024.
//

import SwiftUI

struct StartSwipingButton: View {
    var body: some View {
        ZStack(alignment: .bottomLeading){
            // Background image or color for the button
            Color.pink
                .frame(height: 150)
                .clipShape(.rect(cornerRadius: 10))
            
            // Text with an outline and gradient background
            VStack(alignment: .leading) {
                Text("Start Swiping!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    
                
                Text("Discover new Anime matches")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]), startPoint: .bottom, endPoint: .top))
        }
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    StartSwipingButton()
}
