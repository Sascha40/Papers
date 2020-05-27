//
//  PaperView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperView: View {
    var passedPaper: Paper
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Image(uiImage: self.passedPaper.rectoImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 310, height: 230)
                                .cornerRadius(15)
                            
                            
                            Image(uiImage: self.passedPaper.versoImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 310, height:230)
                                .cornerRadius(15)
                            
                        }
                    }
                    .frame(height: 240)
                    .shadow(radius: 10)
                }
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title)
                    Text("\(self.passedPaper.userDescription)")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Type de paper : \(self.passedPaper.category!.name)")
                }
                Spacer()
                    .padding()
            }
        }
        .navigationBarTitle(self.passedPaper.name)
    }
}


//
//struct PaperView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaperView(passedPaper: Paper(name: "test", userDescription: "test", rectoImage: UIImage(named: "recto")!, versoImage: UIImage(named: "verso")!, expirationDate: Date(), addDate: Date()))
//    }
//}
