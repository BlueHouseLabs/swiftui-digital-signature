//
//  Preview.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI

struct SignatureViewTest: View {
    @State private var image: UIImage? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("GO", destination: SignatureView(
                    availableTabs: [.draw, .image, .type],
                    onSave: { image in
                        self.image = image
                    }, onCancel: {
                        
                    }
                ))
                if image != nil {
                    Image(uiImage: image!)
                }
            }
        }
    }
}

struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureViewTest()
    }
}
