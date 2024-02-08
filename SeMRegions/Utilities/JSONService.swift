//
//  JSONService.swift
//  SeMRegions
//
//  Created by Frans-Jan Wind on 06/12/2023.
//

import Foundation

class JSONService {
    
    static func decodeRectangles(from jsonData: Data) -> [RectangleData] {
        (try? JSONDecoder().decode([RectangleData].self, from: jsonData)) ?? []
    }

    static func encodeRectangles(_ rectangles: [RectangleData]) -> Data? {
        try? JSONEncoder().encode(rectangles)
    }

    // Load JSON data from a file in the main bundle
    static func loadFromBundle(fileName: String) -> [RectangleData] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error: Could not find \(fileName).json in the bundle.")
            return []
        }
        print("Loading JSON from URL: \(url)")

        do {
            let data = try Data(contentsOf: url)
            let rectangles = decodeRectangles(from: data)
            print("Decoded \(rectangles.count) rectangles from JSON.")
            return rectangles
        } catch {
            print("Error loading JSON from bundle: \(error.localizedDescription)")
            return []
        }
    }

    
    static func loadFromDocumentPicker(_ fileUrl: URL) -> [RectangleData] {
        do {
            let data = try Data(contentsOf: fileUrl)
            return decodeRectangles(from: data)
        } catch {
            print("Error reading from document picker: \(error)")
            return []
        }
    }
    
    // Load JSON data from the Documents directory
    static func loadFromDocuments(fileName: String) -> [RectangleData] {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory?.appendingPathComponent("\(fileName).json")

        guard let url = fileURL, let data = try? Data(contentsOf: url) else {
            return []
        }

        return decodeRectangles(from: data)
    }
    
    static func saveRectangles(_ rectangles: [RectangleData], toFileName fileName: String) {
        guard let data = encodeRectangles(rectangles) else {
            print("Error encoding rectangles.")
            return
        }

        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)

            do {
                try data.write(to: fileURL, options: .atomic)
                print("Saved rectangles to \(fileURL)")
            } catch {
                print("Error saving rectangles: \(error.localizedDescription)")
            }
        }
    }
}

