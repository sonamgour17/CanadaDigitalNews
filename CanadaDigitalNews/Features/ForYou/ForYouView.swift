//
//  ForYouView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import SwiftUI

struct ForYouView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 16) {
            Text("For You tab")
                .font(.title)

            Text("Personalized feed will go here.")
                .foregroundStyle(.secondary)

            Button("Switch to Home tab") {
                router.switchTab(to: .home)
            }
        }
        .padding()
        .navigationTitle("For You")
    }
}
