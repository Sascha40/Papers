//
//  SwiftUIView.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperListView: View {
    @EnvironmentObject var papers: PapersViewModel
    @EnvironmentObject var paperCategory: PaperCategoryViewModel
    
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
    var body: some View {
        
        VStack(alignment: .leading) {
            if self.papers.papers.isEmpty {
                Text("Vous n'avez aucun paper enregistré")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(self.papers.papers) { paper in
                        PaperItemView(paper: paper)
                    }
                }
                
            }
            
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PaperListView()
    }
}
