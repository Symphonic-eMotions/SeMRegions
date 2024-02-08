//
//  RectangleCollectionViewModel.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 06/12/2023.
//

import SwiftUI
import Combine

class RectangleCollectionViewModel: ObservableObject {
    
    @Published var rectangles: [PercentageRectangle] {
        didSet {
            rectangleCollection.rectangles = rectangles
        }
    }

    private var rectangleCollection: PercentageRectangleCollection

    init(rectangleCollection: PercentageRectangleCollection) {
        self.rectangleCollection = rectangleCollection
        self.rectangles = rectangleCollection.rectangles
    }

    var sortedRectangles: [PercentageRectangle] {
        rectangleCollection.sortedRectangles
    }
    
    func updateRectangle(at index: Int, with newStartPoint: CGPoint, and newEndPoint: CGPoint) {
        guard rectangles.indices.contains(index) else { return }
        rectangles[index].startPoint = newStartPoint
        rectangles[index].endPoint = newEndPoint
    }

    // Add other methods that modify `rectangleCollection` and update `rectangles`
}
