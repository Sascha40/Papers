//
//  PapersListView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PapersListView: View {
    
    @EnvironmentObject var papers: PapersViewModel
    @EnvironmentObject var categories: PaperCategoryViewModel
    @State var showEditPaper = false
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    private func delete(at papers: IndexSet) {
        for index in papers {
            let paper = self.papers.papers[index]
            
            guard let recordID = paper.recordId else { return }
            // MARK: - delete from CloudKit
            CloudKitHelper.deletePaper(recordID: recordID) { (result) in
                switch result {
                case .success(let recordID):
                    self.papers.papers.removeAll { (paper) -> Bool in
                        return paper.recordId == recordID
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Avenir-black", size: 32)!, .foregroundColor: UIColor(red: 130/255, green: 198/255, blue: 207/255, alpha: 1.0)]
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        NavigationView {
            VStack {
                if self.papers.papers.isEmpty {
                    Text("Vous n'avez aucun paper enregistré")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(self.papers.papers) { paper in
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
                                            HStack {
                                                Text(paper.category!.name)
                                                    .font(.footnote)
                                                Spacer()
                                            }
                                        }
                                        Text( "Expire le \(paper.expirationDate, formatter: Self.taskDateFormat)")
                                            .font(.subheadline).foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: self.delete)
                    }
                }
            }
            .navigationBarTitle(Text("Mes Papers"))
        }
    }
}

struct PapersListView_Previews: PreviewProvider {
    static var previews: some View {
        PapersListView()
    }
}
