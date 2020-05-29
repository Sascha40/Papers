//
//  CategoryView.swift
//  Papers
//
//  Created by Sascha Sallès on 27/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var papers: PapersViewModel
    @EnvironmentObject var categories: PaperCategoryViewModel
    var category: PaperCategory
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    
    var body: some View {

        VStack(alignment: .leading) {
        
            ForEach(self.papers.papers){ paper in
                    if paper.category!.name == self.category.name {
                        NavigationLink(destination: PaperView(passedPaper: paper)) {
                            HStack {
                                Image(uiImage: paper.rectoImage)
                                    .resizable()
                                    .aspectRatio(paper.rectoImage.size, contentMode: .fill)
                                    .frame(width: 90, height:60)
                                    .cornerRadius(7)
                                    .shadow(radius: 3)
                                
                                VStack(alignment: .leading) {
                                    Text(paper.name)
                                        .font(.headline)
                                    if paper.category != nil {
                                        Text(paper.category!.name)
                                            .font(.callout)
                                    }
                                    Text( "Expire le \(paper.expirationDate, formatter: Self.taskDateFormat)")
                                        .font(.subheadline).foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }.padding()
        .navigationBarTitle(Text(self.category.name), displayMode: .inline)
    }
}


