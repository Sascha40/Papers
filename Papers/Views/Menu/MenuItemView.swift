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
    #if !os(macOS)
    var logo: String
    #endif
    
    var body: some View {
        color
            .frame(width:160, height: 110)
            .shadow(radius: 10)
            .cornerRadius(20)
            .overlay(
                VStack {
                    #if !os(macOS)
                    Image(systemName: logo)
                    .font(.system(size: 25))
                        .foregroundColor(.white)
                    #endif
                    
                    Text(text)
                        .fontWeight(.bold)
                        .font(Font.custom("Avenir-black", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                .padding(3)
        )
            
    }
}

