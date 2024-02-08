//
//  DraggableRectangleView.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 13/12/2023.
//

import SwiftUI

struct DraggableRectangleView: View {
    @ObservedObject var viewModel: RectangleViewModel
    var rectangle: RectangleData

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RectangleView(
                    viewModel: viewModel,
                    rectangle: rectangle
                )
//                .overlay(Group {
//                    if viewModel.isActiveRectangle(rectangle.id) {
//                        ResizeHandlesView(
//                            geometrySize: geometry.size,
//                            rectangle: rectangle,
//                            viewModel: viewModel)
//                    }
//                })
            }
        }
    }
}
