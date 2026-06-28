//  EmptyStateView.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 28/06/26.

import SwiftUI

struct EmptyStateView: View {
    let message: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.secondary)

            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


