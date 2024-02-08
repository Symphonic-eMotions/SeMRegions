//
//  RectangleData.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 06/12/2023.
//

import SwiftUI

struct RectangleData: Codable, Identifiable {
    
    var id: UUID = UUID()
    var x: CGFloat // X position
    var y: CGFloat // Y position
    var width: CGFloat
    var height: CGFloat
    var colorString: String
    
    var color: Color {
        get {
            Color(hex: colorString) ?? .clear
        }
        set {
            colorString = newValue.toHexString()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case x
        case y
        case width
        case height
        case colorString = "color"
    }

    // Initializer
    init(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        colorString: String
    ) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.colorString = colorString
    }
}

