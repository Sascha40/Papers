//
//  PaperItemView.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperItemView: View {
    var paper: Paper
    @EnvironmentObject var papers: PapersViewModel
    @State var showingDetail = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(nsImage: self.paper.rectoImage)
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
        .contextMenu {
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("Afficher \(paper.name)")
            }.sheet(isPresented: $showingDetail) {
                PaperView(passedPaper: self.paper)
            }

            Button(action: {
                guard let recordId = self.paper.recordId else { return }
                CloudKitHelper.deletePaper(recordID: recordId) { (result) in
                    switch result {
                    case .success(let recordID):
                        self.papers.papers.removeAll { (paper) -> Bool in
                            return paper.recordId == recordID
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }) {
                Text("Supprimer \(paper.name)")
            }
        }
    }
}

