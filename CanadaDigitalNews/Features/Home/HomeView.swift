//
//  HomeView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

// Features/Home/HomeView.swift

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 16) {
            Text("Home tab")
                .font(.title)

            Text("Module 3 will put the real news feed here.")
                .foregroundStyle(.secondary)

            Button("Push fake article detail") {
                router.push(.articleDetail(articleID: "demo-123"))
            }

            Button("Switch to For You tab") {
                router.switchTab(to: .forYou)
            }
        }
        .padding()
        .navigationTitle("Top Stories")
    }
}
