//
//  AppConstants.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import Foundation

enum AppConstants {

    enum Strings {
        
        enum Tab {
            static let home = "Home"
            static let forYou = "For You"
        }
        
        enum Home {
            static let navigationTitle = "Top Stories"
            static let searchPrompt = "Search news"
            static let emptyTitle = "No articles"
            static let emptyDescription = "Try a different search, or pull to refresh."
        }

        enum Alert {
            static let errorTitle = "Error"
            static let cancel = "Cancel"
            static let tryAgain = "Try Again"
            static let defaultErrorMessage = "Something went wrong."

        }
    }

    enum Images {
        enum Tab {
            static let home = "house.fill"
            static let forYou = "star.fill"
        }

        enum Home {
            static let emptyState = "newspaper"
        }
    }

    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
    }
}
