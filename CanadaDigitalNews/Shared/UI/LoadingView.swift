//
//  LoadingView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 28/06/26.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        ProgressView()
            .scaleEffect(1.4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
