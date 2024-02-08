//
//  RectangleCollection.swift
//  SeMDraw
//
//  Created by Frans-Jan Wind on 19/11/2023.
//

import Foundation

struct PercentageRectangleCollection: Codable, Hashable {
    
    var rectangles: [PercentageRectangle]

    var sortedRectangles: [PercentageRectangle] {
        return rectangles.sorted { $0.sortOrder < $1.sortOrder }
    }

    // JSON Encoding
    func encodeToJSON() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    // JSON Decoding
    static func decodeFromJSON(_ data: Data) -> PercentageRectangleCollection? {
        return try? JSONDecoder().decode(PercentageRectangleCollection.self, from: data)
    }
    
    // Load from Bundle
    static func loadRectanglesFromBundle(
        fileName: String,
        fileExtension: String
    ) -> PercentageRectangleCollection? {
        
        guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            print("Error: File not found in bundle.")
            return nil
        }
        
        do {
            // Read the data from the file at the path
            let data = try Data(contentsOf: URL(fileURLWithPath: bundlePath))
            
            // Decode the data into a RectangleCollection instance
            let decodedCollection = try JSONDecoder().decode(PercentageRectangleCollection.self, from: data)
            return decodedCollection
        } catch {
            print("Error loading or decoding file from bundle:", error)
            return nil
        }
    }
    
    // Load from Documents Folder
    static func loadRectanglesFromDocuments() -> PercentageRectangleCollection? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = urls.first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("rectangles.json")

        do {
            let data = try Data(contentsOf: fileURL)
            return PercentageRectangleCollection.decodeFromJSON(data)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    static func loadRectanglesFromFileURL(_ fileURL: URL) -> PercentageRectangleCollection? {
        do {
            let data = try Data(contentsOf: fileURL)
            return PercentageRectangleCollection.decodeFromJSON(data)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
}
