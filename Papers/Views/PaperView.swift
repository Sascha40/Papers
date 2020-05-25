//
//  PaperView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperView: View {
    let paper: Paper
    @EnvironmentObject var papers: PapersViewModel
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    Image(uiImage: paper.rectoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .cornerRadius(10)
                    Image(uiImage: paper.versoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .cornerRadius(10)
                }
            }
            .shadow(radius: 5)
            VStack(alignment: .leading) {
                Text("Description")
                    .font(.title)
                Text("\(paper.userDescription)")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                if paper.category != nil {
                    Text(paper.category!.name)
                }
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.top)
    }
}


