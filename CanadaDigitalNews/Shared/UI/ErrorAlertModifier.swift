//  SharedUI.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 28/06/26.

import Foundation
import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String?
    let retryAction: (() -> Void)?

    func body(content: Content) -> some View {
        content.alert("Error", isPresented: $isPresented) {
            Button("Cancel", role: .cancel) { }
            if let retryAction {
                Button("Try again") { retryAction() }
            }
        } message: {
            Text(message ?? "Something went wrong.")
        }
    }
}

extension View {
    func errorAlert(
        isPresented: Binding<Bool>,
        message: String?,
        retryAction: (() -> Void)? = nil
    ) -> some View {
        modifier(ErrorAlertModifier(
            isPresented: isPresented,
            message: message,
            retryAction: retryAction
        ))
    }
}
