//
//  MenuButton.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 04/12/2023.
//

import SwiftUI

struct MenuButton: View {
    
    @Binding var isMenuExpanded: Bool
    @Binding var showDocumentPicker: Bool

    var body: some View {
        Button(action: { isMenuExpanded.toggle() }) {
            Image(systemName: "line.horizontal.3")
                .font(.title)
                .foregroundColor(.white)
        }
        .popover(isPresented: $isMenuExpanded, content: {
            Button("Select setting file") {
                // Delay the presentation to allow the popover to dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showDocumentPicker = true
                }
                isMenuExpanded = false
            }
            .padding()
        })
    }
}
