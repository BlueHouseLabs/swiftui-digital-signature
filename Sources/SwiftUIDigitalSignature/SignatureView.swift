//
//  SignatureView.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI
import CoreGraphics
import UIKit

public struct SignatureView: View {
    
    public let availableTabs: [Tab]
    public let onSave: (UIImage) -> Void
    public let onCancel: () -> Void
    
    @State private var selectedTab: Tab
    
    private let showColorPicker: Bool
    private let showCancelButton: Bool
    
    private let lineWidth: CGFloat
    private let maxHeight: CGFloat
    private let placeholderText: String
    
    @State private var saveSignature = false
    
    private let fontFamilies: [String]
    @State private var fontFamily: String
    private let fontSize: CGFloat
    @State private var lineColor: Color
    @State private var canvasColor: Color
    
    @State private var drawing = DrawingPath()
    @State private var image = UIImage()
    @State private var isImageSet = false
    @State private var text = ""
    
    public var body: some View {
        VStack {
            HStack() {
                if !showCancelButton {
                    Spacer()
                }
                Button("Done", action: extractImageAndHandle)
                    .font(.body.bold())
                if showCancelButton {
                    Spacer()
                    Button("Cancel", action: onCancel)
                }
            }
            if availableTabs.count > 1 {
                Picker(selection: $selectedTab, label: EmptyView()) {
                    ForEach(availableTabs, id: \.self) { tab in
                        Text(tab.title)
                            .tag(tab)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            signatureContent
                .padding(.vertical)
            Button("Clear signature", action: clear)
            HStack {
                if selectedTab == Tab.type {
                    FontFamilyPicker(
                        selection: $fontFamily,
                        fontFamilies: fontFamilies,
                        placeholderText: placeholderText
                    )
                }
                if showColorPicker {
                    ColorPickerShim(selection: $lineColor)
                }
            }
            Spacer()
        }.padding()
    }
    
    @ViewBuilder private var signatureContent: some View {
        if selectedTab == .draw {
            SignatureDrawView(
                drawing: $drawing,
                fontFamily: fontFamily,
                fontSize: fontSize,
                lineColor: lineColor,
                canvasColor: canvasColor,
                placeholderText: placeholderText,
                maxHeight: maxHeight
            )
        } else if selectedTab == .image {
            SignatureImageView(
                isSet: $isImageSet,
                selection: $image,
                maxHeight: maxHeight
            )
        } else if selectedTab == .type {
            SignatureTypeView(
                text: $text,
                fontFamily: $fontFamily,
                fontSize: fontSize,
                color: $lineColor,
                placeholderText: placeholderText
            )
        }
    }
    
    public init(
        availableTabs: [Tab] = Tab.allCases,
        showColorPicker: Bool = true,
        lineColor: Color = .blue,
        canvasColor: Color = .white,
        lineWidth: CGFloat = 5,
        placeholderText: String = "Signature",
        fontFamilies: [String] = ["Zapfino", "SavoyeLetPlain", "SnellRoundhand", "SnellRoundhand-Black"],
        fontSize: CGFloat = 44.0,
        maxHeight: CGFloat = 160,
        showCancelButton: Bool = true,
        onSave: @escaping (UIImage) -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        self.availableTabs = availableTabs
        self.showColorPicker = showColorPicker
        self.lineColor = lineColor
        self.canvasColor = canvasColor
        self.lineWidth = lineWidth
        self.placeholderText = placeholderText
        self.fontFamilies = fontFamilies
        self.fontFamily = fontFamilies[0]
        self.fontSize = fontSize
        self.maxHeight = maxHeight
        self.showCancelButton = showCancelButton
        self.onSave = onSave
        self.onCancel = onCancel
        
        self.selectedTab = availableTabs.first!
    }
    
    private func extractImageAndHandle() {
        let image: UIImage
        switch selectedTab {
        case .draw:
            let path = drawing.cgPath
            let maxX = drawing.points.map { $0.x }.max() ?? 0
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxX, height: maxHeight))
            let uiImage = renderer.image { ctx in
                ctx.cgContext.setStrokeColor(lineColor.uiColor.cgColor)
                ctx.cgContext.setLineWidth(lineWidth)
                ctx.cgContext.beginPath()
                ctx.cgContext.addPath(path)
                ctx.cgContext.drawPath(using: .stroke)
            }
            image = uiImage
        case .image:
            image = self.image
        case .type:
            let rendererWidth: CGFloat = 512
            let rendererHeight: CGFloat = 128
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: rendererWidth, height: rendererHeight))
            let uiImage = renderer.image { ctx in
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs = [
                    NSAttributedString.Key.font: UIFont(name: fontFamily, size: fontSize)!,
                    NSAttributedString.Key.foregroundColor: lineColor.uiColor,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                text.draw(
                    with: CGRect(x: 0, y: 0, width: rendererWidth, height: rendererHeight),
                    options: .usesLineFragmentOrigin,
                    attributes: attrs,
                    context: nil
                )
            }
            image = uiImage
        }
        if saveSignature {
            if let data = image.pngData(),
               let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filename = docsDir.appendingPathComponent("Signature-\(Date()).png")
                try? data.write(to: filename)
            }
        }
        onSave(image)
    }
    
    private func clear() {
        drawing = DrawingPath()
        image = UIImage()
        isImageSet = false
        text = ""
    }
    
    public enum Tab: CaseIterable, Hashable {
        case draw, image, type
        
        var title: LocalizedStringKey {
            switch self {
            case .draw:
                return "Draw"
            case .image:
                return "Image"
            case .type:
                return "Type"
            }
        }
    }
}
