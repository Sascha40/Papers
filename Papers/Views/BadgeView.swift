//
//  CategoryBadgeView.swift
//  Papers
//
//  Created by Sascha Sallès on 27/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    var color: Color
    var text: String
    #if !os(macOS)
    var logo: String
    #endif
    
    var body: some View {
        self.color
            .frame(width: 125, height: 33)
            .cornerRadius(30)
            .overlay(
                HStack {
                    #if !os(macOS)
                    Image(systemName: logo)
                        .foregroundColor(.white)
                    #endif
                    Text(text)
                        .font(Font.custom("Avenir-black", size: 17))
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
                .padding(10)
        )
    }
}

struct CategoryBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(color: Color.purple, text: "Shopping", logo: "bag.fill")
    }
}
