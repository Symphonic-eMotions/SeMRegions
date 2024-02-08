//
//  FileUtility.swift
//  SeMDraw
//
//  Created by Frans-Jan Wind on 04/12/2023.
//

import Foundation

// Utility functions related to file management
class FileUtility {
    
    static func copyFileToDocumentsFolder(
        fileName: String,
        fileExtension: String
    ) {
        
        let fileManager = FileManager.default

        // Get the path to the file in the bundle
        guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            print("Error: File not found in bundle.")
            return
        }

        // Get the path to the documents directory
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Documents directory not found.")
            return
        }

        // Create the destination URL
        let destinationURL = documentsDirectory.appendingPathComponent("\(fileName).\(fileExtension)")
        
        print(destinationURL)
        
        // Check if the file already exists at the destination
        if !fileManager.fileExists(atPath: destinationURL.path) {
            do {
                // Copy the file to the documents directory
                try fileManager.copyItem(atPath: bundlePath, toPath: destinationURL.path)
                print("File copied successfully to Documents folder.")
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("File already exists at destination.")
        }
    }
}
