//
//  PinchableImageView.swift
//  Papers
//
//  Created by Sascha Sallès on 27/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PinchableImageView: View {
    var image: UIImage
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                Image(uiImage: self.image)
                    .frame(width: geometry.size.width/2)
            }
            
        }
    }
}

struct PinchableImageView_Previews: PreviewProvider {
    static var previews: some View {
        PinchableImageView(image: UIImage(named: "ph_recto")!)
    }
}
