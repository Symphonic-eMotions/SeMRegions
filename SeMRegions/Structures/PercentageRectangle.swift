//
//  PercentageRectangle.swift
//  SeMDraw
//
//  Created by Frans-Jan Wind on 19/11/2023.
//

import SwiftUI

struct CGPoint: Codable, Equatable {
    var x: CGFloat
    var y: CGFloat
}


enum Orientation: String, Codable {
    case landscape
    case portrait
}

struct PercentageRectangle: Codable, Hashable {

    var startPoint: CGPoint
    var endPoint: CGPoint
    var orientation: Orientation
    var colorString: String
    var sortOrder: Int

    // Custom CodingKeys
    enum CodingKeys: String, CodingKey {
        case startPoint
        case endPoint
        case orientation
        case colorString = "color"  // Custom key if the JSON key is "color"
        case sortOrder
    }
    
    // You may need to implement the hash(into:) function if your struct has properties that are not themselves Hashable.
    func hash(into hasher: inout Hasher) {
        hasher.combine(startPoint.x)
        hasher.combine(startPoint.y)
        hasher.combine(endPoint.x)
        hasher.combine(endPoint.y)
        hasher.combine(orientation) // Make sure that RectangleOrientation also conforms to Hashable
        hasher.combine(colorString)
        hasher.combine(sortOrder)
    }

    // Equatable conformance might be needed as well
    static func == (lhs: PercentageRectangle, rhs: PercentageRectangle) -> Bool {
        lhs.startPoint == rhs.startPoint &&
        lhs.endPoint == rhs.endPoint &&
        lhs.orientation == rhs.orientation &&
        lhs.colorString == rhs.colorString &&
        lhs.sortOrder == rhs.sortOrder
    }
    
    var rect: CGRect {
        let width = abs(endPoint.x - startPoint.x)
        let height = abs(endPoint.y - startPoint.y)
        let originX = min(startPoint.x, endPoint.x)
        let originY = min(startPoint.y, endPoint.y)

        let screenSize = UIScreen.main.bounds.size
        let screenWidth = orientation == .landscape ? max(screenSize.width, screenSize.height) : min(screenSize.width, screenSize.height)
        let screenHeight = orientation == .landscape ? min(screenSize.width, screenSize.height) : max(screenSize.width, screenSize.height)

        let widthPercentage = (width / screenWidth) * 100
        let heightPercentage = (height / screenHeight) * 100

        return CGRect(x: originX, y: originY, width: widthPercentage, height: heightPercentage)
    }
    
    var color: Color {
        get {
            Color(hex: colorString) ?? .clear
        }
        set {
            colorString = newValue.toHexString()
        }
    }
    
    init(
        startPoint: CGPoint,
        endPoint: CGPoint,
        orientation: Orientation,
        colorString: String,
        sortOrder: Int
    ) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.orientation = orientation
        self.colorString = colorString
        self.sortOrder = sortOrder
    }
    
    func calculateDrawingRect(in size: CGSize) -> CGRect {
         let screenWidth = orientation == .landscape ? max(size.width, size.height) : min(size.width, size.height)
         let screenHeight = orientation == .landscape ? min(size.width, size.height) : max(size.width, size.height)

         let width = (abs(endPoint.x - startPoint.x) / screenWidth) * size.width
         let height = (abs(endPoint.y - startPoint.y) / screenHeight) * size.height
         let originX = min(startPoint.x, endPoint.x) / screenWidth * size.width
         let originY = min(startPoint.y, endPoint.y) / screenHeight * size.height

         return CGRect(x: originX, y: originY, width: width, height: height)
     }
}
