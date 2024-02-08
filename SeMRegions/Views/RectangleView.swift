//
//  RectanglesView.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 06/12/2023.
//

import SwiftUI

struct RectangleView: View {
    @ObservedObject var viewModel: RectangleViewModel
    var rectangle: RectangleData
    @State private var initialPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        GeometryReader { geometry in
            
            let frameWidth = rectangle.width * geometry.size.width
            let frameHeight = rectangle.height * geometry.size.height
            let frameX = rectangle.x * geometry.size.width + (frameWidth / 2)
            let frameY = rectangle.y * geometry.size.height + (frameHeight / 2)
            
            Rectangle()
            .stroke(rectangle.color, lineWidth: viewModel.activeRectangleID == rectangle.id ? 8 : 2)
            .contentShape(Rectangle())
            .frame(width: rectangle.width * geometry.size.width, height: rectangle.height * geometry.size.height)
            .position(x: rectangle.x * geometry.size.width, y: rectangle.y * geometry.size.height)
            .overlay {
                if viewModel.isActiveRectangle(rectangle.id) {
                    // Handles are placed using alignment within the overlay,
                    // thus positioning them relative to the rectangle's frame.
                    Group {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                            .offset(x: -frameWidth / 2, y: -frameHeight / 2) // Top Left
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                            .offset(x: frameWidth / 2 - 20, y: -frameHeight / 2) // Top Right
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                            .offset(x: -frameWidth / 2, y: frameHeight / 2 - 20) // Bottom Left
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                            .offset(x: frameWidth / 2 - 20, y: frameHeight / 2 - 20) // Bottom Right
                    }
                    // No need for alignment as offset is calculated based on the rectangle's size.
                }
            }
            .onTapGesture {
                viewModel.setActiveRectangle(rectangle.id)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if initialPosition == CGPoint(x: 0, y: 0) {
                            initialPosition = CGPoint(x: rectangle.x * geometry.size.width, y: rectangle.y * geometry.size.height)
                        }
                        let newPosX = (initialPosition.x + value.translation.width) / geometry.size.width
                        let newPosY = (initialPosition.y + value.translation.height) / geometry.size.height
                        viewModel.updateRectangle(id: rectangle.id, newPositionX: newPosX, newPositionY: newPosY)
                    }
                    .onEnded { _ in
                        initialPosition = CGPoint(x: 0, y: 0)
                    }
            )
        }
    }

    private func updatePosition(with translation: CGSize, in geometrySize: CGSize) {
        let newX = (initialPosition.x + translation.width) / geometrySize.width
        let newY = (initialPosition.y + translation.height) / geometrySize.height
        viewModel.updateRectangle(id: rectangle.id, newPositionX: newX, newPositionY: newY)
    }
}
