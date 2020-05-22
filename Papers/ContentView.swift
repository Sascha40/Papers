//
//  ContentView.swift
//  Papers
//
//  Created by Sascha Sallès on 22/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @EnvironmentObject  var papers: Papers
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "FR.fr")
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List(papers.papers) { paper in
                NavigationLink(destination: PaperView()) {
                    HStack {
                        Text(paper.name)
                        //                    Text( "\(paper.addDate, formatter: Self.taskDateFormat)")
                        Text( "\(paper.expirationDate, formatter: Self.taskDateFormat)")
                        Image(uiImage: paper.rectoImage).resizable().frame(width: 140, height: 90)
                    }
                }
                
                //                Text(paper.userDescription)
                
                
            }
        }
        .onAppear(){
            CloudKitHelper.fetch { (result) in
                switch result {
                case .success(let newPaper):
                    self.papers.papers.append(newPaper)
                    print(newPaper)
                    print("Successfully fetched item")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
