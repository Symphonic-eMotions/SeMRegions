//
//  Color.swift
//  SeMDraw
//
//  Created by Frans-Jan Wind on 19/11/2023.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        let r, g, b, a: Double

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = Double((hexNumber & 0xff000000) >> 24) / 255
                    g = Double((hexNumber & 0x00ff0000) >> 16) / 255
                    b = Double((hexNumber & 0x0000ff00) >> 8) / 255
                    a = Double(hexNumber & 0x000000ff) / 255

                    self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
                    return
                }
            }
        }

        return nil
    }

    func toHexString() -> String {
        // Convert the Color to a UIColor
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Convert to hex string
        let rgb: Int = (Int)(red * 255) << 24 | (Int)(green * 255) << 16 | (Int)(blue * 255) << 8 | (Int)(alpha * 255)
        
        return String(format: "#%08x", rgb)
    }
}
