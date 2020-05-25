//
//  PapersListView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PapersListView: View {
    @ObservedObject  var papers = PapersViewModel()
    @State var showAddPaper = false
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Avenir-black", size: 32)!, .foregroundColor: UIColor.init(red: 69/255, green: 140/255, blue: 157/255, alpha: 1.0)]
    }
    var body: some View {
        LoadingView(isShowing: .constant(self.papers.loading)) {
            NavigationView {
                List(self.papers.papers) { paper in
                    NavigationLink(destination: PaperView(paper: paper)) {
                        HStack {
                            Image(uiImage: paper.rectoImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(3)
                                .frame(height:60)
                            VStack(alignment: .leading) {
                                Text(paper.name)
                                    .font(.headline)
                                Text( "Expire le \(paper.expirationDate, formatter: Self.taskDateFormat)")
                                    .font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Mes Papers"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showAddPaper.toggle()
                    }) {
                        Text("Modifier")
                    }.sheet(isPresented: self.$showAddPaper) {
                        EditPaperView(isPresented: self.$showAddPaper)
                    }
                )
            }
        }
    }
}

struct PapersListView_Previews: PreviewProvider {
    static var previews: some View {
        PapersListView()
    }
}
