//
//  SignatureImageView.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI

struct SignatureImageView: View {
    @Binding var isSet: Bool
    @Binding var selection: UIImage
    
    let maxHeight: CGFloat
    
    @State private var showPopover = false
    
    var body: some View {
        Button(action: {
            showPopover.toggle()
        }) {
            if isSet {
                Image(uiImage: selection)
                    .resizable()
                    .frame(maxHeight: maxHeight)
            } else {
                ZStack {
                    Color.white
                    Text("Choose signature image")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .frame(height: maxHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray)
                )
            }
        }.popover(isPresented: $showPopover) {
            ImagePicker(selectedImage: $selection, didSet: $isSet)
        }
    }
}
