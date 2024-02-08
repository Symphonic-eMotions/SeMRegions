//
//  ResizeHandlesView.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 13/12/2023.
//

import SwiftUI

enum Corner {
    case topLeft, topRight, bottomLeft, bottomRight
}

struct ResizeHandlesView: View {
    var geometrySize: CGSize
    var rectangle: RectangleData
    @ObservedObject var viewModel: RectangleViewModel

    var body: some View {
        Group {
            resizeHandle(at: .topLeft, in: geometrySize, rectangle.color)
            resizeHandle(at: .topRight, in: geometrySize, rectangle.color)
            resizeHandle(at: .bottomLeft, in: geometrySize, rectangle.color)
            resizeHandle(at: .bottomRight, in: geometrySize, rectangle.color)
        }
        .offset(x: -100, y: -100)
    }
    
    private func resizeHandle(
        at corner: Corner,
        in geometrySize: CGSize,
        _ color: Color
    ) -> some View {
        Circle()
        .frame(width: 20, height: 20)
        .foregroundColor(color)
        .position(positionForHandle(corner, in: geometrySize))
        .gesture(
            DragGesture()
                .onChanged { value in
                    updateSize(for: corner, with: value.translation, in: geometrySize)
                }
        )
    }
    
    private func positionForHandle(_ corner: Corner, in size: CGSize) -> CoreFoundation.CGPoint {

        let position: CoreFoundation.CGPoint
        
        switch corner {
        case .topLeft:
            position = CoreFoundation.CGPoint(
                x: rectangle.x * size.width,
                y: rectangle.y * size.height
            )
        case .topRight:
            position =  CoreFoundation.CGPoint(
                x: (rectangle.x + rectangle.width) * size.width,
                y: rectangle.y * size.height
            )
        case .bottomLeft:
            position =  CoreFoundation.CGPoint(
                x: rectangle.x * size.width,
                y: (rectangle.y + rectangle.height) * size.height
            )
        case .bottomRight:
            position =  CoreFoundation.CGPoint(
                x: (rectangle.x + rectangle.width) * size.width,
                y: (rectangle.y + rectangle.height) * size.height
            )
        }
        
        print("Handle \(corner) for Rectangle ID: \(rectangle.id), Position: \(position), Size: \(size)")
        return position
        
    }
    
    private func updateSize(for corner: Corner, with translation: CGSize, in size: CGSize) {
        switch corner {
        case .topLeft:
            let newWidth = rectangle.width * size.width - translation.width
            let newHeight = rectangle.height * size.height - translation.height
            let newX = rectangle.x * size.width + translation.width / size.width
            let newY = rectangle.y * size.height + translation.height / size.height
            viewModel.updateRectangleSizeAndPosition(id: rectangle.id, newPositionX: newX, newPositionY: newY, newWidth: newWidth, newHeight: newHeight)

        case .topRight:
            let newWidth = rectangle.width * size.width + translation.width
            let newHeight = rectangle.height * size.height - translation.height
            let newY = rectangle.y * size.height + translation.height / size.height
            viewModel.updateRectangleSizeAndPosition(id: rectangle.id, newPositionY: newY, newWidth: newWidth, newHeight: newHeight)

        case .bottomLeft:
            let newWidth = rectangle.width * size.width - translation.width
            let newHeight = rectangle.height * size.height + translation.height
            let newX = rectangle.x * size.width + translation.width / size.width
            viewModel.updateRectangleSizeAndPosition(id: rectangle.id, newPositionX: newX, newWidth: newWidth, newHeight: newHeight)

        case .bottomRight:
            let newWidth = rectangle.width * size.width + translation.width
            let newHeight = rectangle.height * size.height + translation.height
            viewModel.updateRectangleSizeAndPosition(id: rectangle.id, newWidth: newWidth, newHeight: newHeight)
        }
    }
}
