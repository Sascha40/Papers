//
//  MenuItem.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct MenuItemView: View {
    var color: Color
    var text: String
    
    
    var body: some View {
        color
            .frame(height: 80)
            .cornerRadius(15)
            .overlay(
                VStack {
                    Text(text)
                        .fontWeight(.bold)
                        .font(Font.system(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }.padding(10)
        )
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView(color: Color(hex: "#ccc"), text: "Shopping")
            .previewLayout(.sizeThatFits)
    }
}
