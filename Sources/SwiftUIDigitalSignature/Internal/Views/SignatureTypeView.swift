//
//  SignatureTypeView.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI

struct SignatureTypeView: View {
    @Binding var text: String
    @Binding var fontFamily: String
    let fontSize: CGFloat
    @Binding var color: Color
    
    let placeholderText: String
    
    var body: some View {
        TextField(placeholderText, text: $text)
            .disableAutocorrection(true)
            .font(.custom(fontFamily, size: fontSize))
            .foregroundColor(color)
    }
}
