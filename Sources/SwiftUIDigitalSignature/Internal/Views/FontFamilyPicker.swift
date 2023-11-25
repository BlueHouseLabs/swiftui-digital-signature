//
//  FontFamilyPicker.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI

struct FontFamilyPicker: View {
    @Binding var selection: String
    private let fontFamilies: [String]
    private let placeholderText: String
    
    @State private var showPopover = false
    
    
    var body: some View {
        Button(action: {
            showPopover.toggle()
        }, label: {
            buttonLabel(selection, size: 16)
        }).popover(isPresented: $showPopover) {
            VStack(spacing: 20) {
                ForEach(self.fontFamilies, id: \.self) { fontFamily in
                    Button(action: {
                        selection = fontFamily
                        showPopover.toggle()
                    }, label: {
                        buttonLabel(fontFamily, size: 24)
                    })
                }
            }
        }
    }
    
    init(
        selection: Binding<String>,
        fontFamilies: [String],
        placeholderText: String
    ) {
        self._selection = selection
        self.fontFamilies = fontFamilies
        self.placeholderText = placeholderText
    }
    
    private func buttonLabel(_ fontFamily: String, size: CGFloat) -> Text {
        Text(placeholderText)
            .font(.custom(fontFamily, size: size))
            .foregroundColor(.black)
    }
}
