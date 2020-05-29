//
//  PaperItemView.swift
//  Papers
//
//  Created by Sascha Sallès on 27/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperItemView: View {
    var paper: Paper
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: self.paper.rectoImage)
                .resizable()
                .aspectRatio(self.paper.rectoImage.size, contentMode: .fill)
                .frame(width:260, height:170)
                .cornerRadius(15)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(paper.name)
                    .font(Font.custom("Avenir-black", size: 25))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .gray, radius:8, x: 5, y: 1)
                
                BadgeView(color: paper.category!.color, text: paper.category!.name, logo: paper.category!.logo)
            }
            .padding(10)
        }
        .frame(height: 175)
    }
}

