//
//  RectangleDrawingView.swift
//  SeMDraw
//
//  Created by Frans-Jan Wind on 19/11/2023.
//

import SwiftUI

struct RectangleDrawingView: View {
    
    @ObservedObject var viewModel: RectangleCollectionViewModel
    let rectangleIndex: Int
    let screenSize: CGSize

    @State private var isDragging = false
    @State private var initialStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    @State private var initialEndPoint: CGPoint = CGPoint(x: 0, y: 0)

    private var rectangle: PercentageRectangle {
        viewModel.rectangles[rectangleIndex]
    }

    var dragGesture: some Gesture {
        DragGesture()
        .onChanged { value in
            if !isDragging {
                initialStartPoint = viewModel.rectangles[rectangleIndex].startPoint
                initialEndPoint = viewModel.rectangles[rectangleIndex].endPoint
                isDragging = true
            }

            // Debugging
            print("Screen Size: \(screenSize)")
            print("Translation: \(value.translation.width), \(value.translation.height)")

            let translationXPercent = (value.translation.width / screenSize.width) * 100
            let translationYPercent = (value.translation.height / screenSize.height) * 100

            // Debugging
            print("Translation Percent: \(translationXPercent)%, \(translationYPercent)%")

            let newStartPoint = CGPoint(x: initialStartPoint.x + translationXPercent, y: initialStartPoint.y + translationYPercent)
            let newEndPoint = CGPoint(x: initialEndPoint.x + translationXPercent, y: initialEndPoint.y + translationYPercent)

            // Debugging
            print("New Start Point: \(newStartPoint), New End Point: \(newEndPoint)")

            viewModel.updateRectangle(at: rectangleIndex, with: newStartPoint, and: newEndPoint)
        }
        .onEnded { _ in
            isDragging = false
        }
    }

    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let rect = rectangle.calculateDrawingRect(in: geometry.size)
                path.addRect(rect)
            }
            .stroke(rectangle.color, lineWidth: 7)
            .background(Color.clear.contentShape(Rectangle()))
            .onAppear {
                initialStartPoint = rectangle.startPoint
                initialEndPoint = rectangle.endPoint
            }
        }
        .gesture(dragGesture)
        .edgesIgnoringSafeArea(.all)
    }
}
