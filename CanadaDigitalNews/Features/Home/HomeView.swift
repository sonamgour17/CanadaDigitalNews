//
//  HomeView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import SwiftUI

struct HomeView: View {

    @StateObject var vm = HomeViewModel(apiClient: APIClient.shared)

    var body: some View {

        VStack {
            Text("Home")

            if vm.isLoading {
                ProgressView()
            }

            List(vm.articles, id: \.title) { article in
                Text(article.title!)
                    .font(.title)
                    .foregroundStyle(.red)
            }

        }
        .task {
            await vm.fetchNews()
        }
    }
}

#Preview {
    HomeView()
}
