
//
//  PaperView.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperView: View {

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    @EnvironmentObject var papers: PapersViewModel
    var passedPaper: Paper
    @State var presentEditView = false
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    if self.passedPaper.category != nil {
                        BadgeView(color: self.passedPaper.category!.color, text: self.passedPaper.category!.name, logo: self.passedPaper.category!.logo)
                    }
                    Spacer()
                    Text("Expire le \(self.passedPaper.expirationDate, formatter: Self.taskDateFormat)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                HStack(spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Image(nsImage: self.passedPaper.rectoImage)
                                .resizable()
                                .aspectRatio(self.passedPaper.rectoImage.size, contentMode: .fill)
                                .frame(width: 300, height: 230)
                                .cornerRadius(15)
                            
                            
                            Image(nsImage: self.passedPaper.versoImage)
                                .resizable()
                                .aspectRatio(self.passedPaper.versoImage.size, contentMode: .fill)
                                .frame(width: 300, height: 230)
                                .cornerRadius(15)
                        }.padding([.trailing, .leading])
                    }
                    .frame(height: 240)
                    .shadow(radius: 10)
                }
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nom")
                            .font(Font.custom("Avenir-black", size: 23))
                            .bold()
                        Text("\(self.passedPaper.name)")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("Description")
                            .font(Font.custom("Avenir-black", size: 23))
                            .bold()
                        Text("\(self.passedPaper.userDescription)")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Date d'ajout")
                            .font(Font.custom("Avenir-black", size: 23))
                            .bold()
                        
                        Text("Ajouté le \(self.passedPaper.addDate, formatter: Self.taskDateFormat)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
        }
    }
}
