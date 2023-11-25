//
//  ColorPickerShim.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI

struct ColorPickerShim: View {
    @Binding var selection: Color
    
    @State private var showPopover = false
    private let availableColors: [Color] = [.blue, .black, .red]
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ColorPicker(selection: $selection) {
                EmptyView()
            }
        } else {
            Button(action: {
                showPopover.toggle()
            }, label: {
                colorCircle(selection)
            }).popover(isPresented: $showPopover) {
                ForEach(availableColors, id: \.self) { color in
                    Button(action: {
                        selection = color
                        showPopover.toggle()
                    }, label: {
                        colorCircle(color)
                    })
                }
            }
        }
    }
    
    private func colorCircle(_ color: Color) -> some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 32, height: 32)
    }
}
