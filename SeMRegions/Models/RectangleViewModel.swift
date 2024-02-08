//
//  RectangleViewModel.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 06/12/2023.
//

import SwiftUI

class RectangleViewModel: ObservableObject {
    
    @Published var rectangles: [RectangleData]
    @Published var activeRectangleID: UUID?

    init(rectangles: [RectangleData] = []) {
        self.rectangles = rectangles
    }

    func addRectangle(_ rectangle: RectangleData) {
        rectangles.append(rectangle)
    }

    func updateRectangle(id: UUID, newPositionX: CGFloat, newPositionY: CGFloat) {
        if let index = rectangles.firstIndex(where: { $0.id == id }) {
            rectangles[index].x = newPositionX
            rectangles[index].y = newPositionY
        }
    }
    
    func isActiveRectangle(_ id: UUID) -> Bool {
        print("Checking if rectangle is active: \(id)")
        return id == activeRectangleID
    }

    func setActiveRectangle(_ id: UUID) {
        activeRectangleID = id
        print("Active Rectangle Set: \(id)")
    }
    
    func updateRectangleSizeAndPosition(id: UUID, newPositionX: CGFloat? = nil, newPositionY: CGFloat? = nil, newWidth: CGFloat, newHeight: CGFloat) {
        guard let index = rectangles.firstIndex(where: { $0.id == id }) else { return }

        if let newX = newPositionX {
            rectangles[index].x = newX / newWidth
        }

        if let newY = newPositionY {
            rectangles[index].y = newY / newHeight
        }

        rectangles[index].width = newWidth / newWidth
        rectangles[index].height = newHeight / newHeight
    }
    
    // This function generates the overlay content for resize handles.
    func overlayForActiveRectangle(_ rectangle: RectangleData, size: CGSize) -> some View {
        Group {
            if isActiveRectangle(rectangle.id) {
                // Top-left handle
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .offset(x: -10, y: -10) // Center the handle

                // Top-right handle
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
                    .offset(x: size.width - 10, y: -10)

                // Bottom-left handle
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .offset(x: -10, y: size.height - 10)

                // Bottom-right handle
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 20, height: 20)
                    .offset(x: size.width - 10, y: size.height - 10)
            }
        }
    }

}
