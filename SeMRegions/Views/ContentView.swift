//
//  ContentView.swift
//  SeMDraw
//
//  Created by Frans-Jan Wind on 18/11/2023.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var isMenuExpanded = false
    @State private var showDocumentPicker = false
    @ObservedObject private var viewModel: RectangleViewModel

    init() {
        _viewModel = ObservedObject(initialValue: RectangleViewModel())
        viewModel.rectangles = JSONService.loadFromBundle(fileName: "rectanglesData")
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraView()
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(viewModel.rectangles) { rectangle in
                    DraggableRectangleView(
                        viewModel: viewModel,
                        rectangle: rectangle
                    )
                }

//            GeometryReader { geometry in
//                ZStack(alignment: .topTrailing) {
//
//                    Color.clear.contentShape(Rectangle())
//
//                    MenuButton(
//                        isMenuExpanded: $isMenuExpanded,
//                        showDocumentPicker: $showDocumentPicker
//                    )
//                    .padding(.trailing, 20)
//                    .padding(.top, 20)
//                }
//            }
                
                Button("Save Rectangles") {
                    let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short).replacingOccurrences(of: "/", with: "-").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "_")
                    let fileName = "rectanglesData_\(timestamp).json"
                    JSONService.saveRectangles(viewModel.rectangles, toFileName: fileName)
                }
                
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                let newCollection = JSONService.loadFromDocumentPicker(url)
                viewModel.rectangles = newCollection
            }
        }
    }
}

#Preview {
    ContentView()
}
