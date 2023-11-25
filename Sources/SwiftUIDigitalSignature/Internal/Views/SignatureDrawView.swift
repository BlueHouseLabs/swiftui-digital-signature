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
    
    private var fontFamily: String
    private var fontSize: CGFloat
    private var color: Color
    private var placeholderText: String
    private var maxHeight: CGFloat
    
    @State private var drawingBounds: CGRect = .zero
    
    var body: some View {
        ZStack {
            Color.clear
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
            } else {
                DrawShape(drawingPath: drawing)
                    .stroke(style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
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
        color: Color,
        placeholderText: String,
        maxHeight: CGFloat
    ) {
        self._drawing = drawing
        self.fontFamily = fontFamily
        self.fontSize = fontSize
        self.color = color
        self.placeholderText = placeholderText
        self.maxHeight = maxHeight
    }
}
