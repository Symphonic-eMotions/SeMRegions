//
//  Chatting.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 18/12/2023.
//

import SwiftUI

struct DraggableRectangleView2: View {
    @ObservedObject var viewModel: RectangleViewModel
    var rectangle: RectangleData

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RectangleView2(
                    viewModel: viewModel,
                    rectangle: rectangle
                )
                .overlay(Group {
                    if viewModel.isActiveRectangle(rectangle.id) {
                        ResizeHandlesView2(
                            geometrySize: geometry.size,
                            rectangle: rectangle,
                            viewModel: viewModel)
                    }
                })
            }
        }
    }
}

struct RectangleView2: View {
    @ObservedObject var viewModel: RectangleViewModel
    var rectangle: RectangleData
    @State private var initialPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .stroke(rectangle.color, lineWidth: viewModel.activeRectangleID == rectangle.id ? 8 : 2)
            .contentShape(Rectangle())
            .frame(width: rectangle.width * geometry.size.width, height: rectangle.height * geometry.size.height)
            .position(x: rectangle.x * geometry.size.width, y: rectangle.y * geometry.size.height)
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


struct ResizeHandlesView2: View {
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
            position = CoreFoundation.CGPoint(x: rectangle.x * size.width, y: rectangle.y * size.height)
        case .topRight:
            position =  CoreFoundation.CGPoint(x: (rectangle.x + rectangle.width) * size.width, y: rectangle.y * size.height)
        case .bottomLeft:
            position =  CoreFoundation.CGPoint(x: rectangle.x * size.width, y: (rectangle.y + rectangle.height) * size.height)
        case .bottomRight:
            position =  CoreFoundation.CGPoint(x: (rectangle.x + rectangle.width) * size.width, y: (rectangle.y + rectangle.height) * size.height)
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
