//
//  SignatureDrawView.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct SignatureDrawView: View {
    @Binding var drawing: DrawingPath
    
    private let fontFamily: String
    private let fontSize: CGFloat
    private let lineColor: Color
    private let canvasColor: Color
    private let placeholderText: String
    private let maxHeight: CGFloat
    
    @State private var drawingBounds: CGRect = .zero
    
    var body: some View {
        ZStack {
            canvasColor
                .background(GeometryReader { geometry in
                    Color.clear.preference(
                        key: FramePreferenceKey.self,
                        value: geometry.frame(in: .local)
                    )
                })
                .onPreferenceChange(FramePreferenceKey.self) { bounds in
                    drawingBounds = bounds
                }
            if drawing.isEmpty {
                Text(placeholderText)
                    .foregroundColor(.gray)
                    .font(.custom(fontFamily, size: fontSize))
                    .frame(maxWidth: .infinity)
            } else {
                DrawShape(drawingPath: drawing)
                    .stroke(style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .foregroundColor(lineColor)
            }
        }
        .frame(height: maxHeight)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if drawingBounds.contains(value.location) {
                        drawing.addPoint(value.location)
                    } else {
                        drawing.addBreak()
                    }
                }
                .onEnded { value in
                    drawing.addBreak()
                }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray)
        )
    }
    
    init(
        drawing: Binding<DrawingPath>,
        fontFamily: String,
        fontSize: CGFloat,
        lineColor: Color,
        canvasColor: Color,
        placeholderText: String,
        maxHeight: CGFloat
    ) {
        self._drawing = drawing
        self.fontFamily = fontFamily
        self.fontSize = fontSize
        self.lineColor = lineColor
        self.canvasColor = canvasColor
        self.placeholderText = placeholderText
        self.maxHeight = maxHeight
    }
}
