//
//  PaperRow.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperRow: View {
    var paper: Paper

    var body: some View {
        HStack(alignment: .center) {
            Image(nsImage: paper.rectoImage)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 32, height: 32)
                .fixedSize(horizontal: true, vertical: false)
                .cornerRadius(4.0)

            VStack(alignment: .leading) {
                Text(paper.name)
                    .fontWeight(.bold)
                    .truncationMode(.tail)
                    .frame(minWidth: 20)

                Text(paper.category!.name)
                    .font(.caption)
                    .opacity(0.625)
                    .truncationMode(.middle)
            }
            Spacer()            
        }
        .padding(.vertical, 4)
    }
}

struct PaperRow_Previews: PreviewProvider {
    static var previews: some View {
        PaperRow(paper: Paper(name: "Carte de crédit", userDescription: "Mon super paper", rectoImage: NSImage(named: "ph_recto")!, versoImage: NSImage(named: "ph_verso")!, expirationDate: Date(), addDate: Date()))
    }
}
