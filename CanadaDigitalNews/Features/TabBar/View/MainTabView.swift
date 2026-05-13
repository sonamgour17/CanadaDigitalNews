//
//  MainTabView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
       
        TabView {
         
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                ForYouView()
            }
            .tabItem {
                Label("ForYou", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainTabView()
}
