
//
//  File.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import Foundation
import CloudKit

class PapersViewModel: ObservableObject {
    @Published var papers =  [Paper]()
    @Published var loading = true
    
    init() {
        fetchPapers()
    }
    
    private func fetchPapers() {
        CloudKitHelper.fetchPapers { (result) in
            switch result {
            case .success(let newPaper):
                self.papers.append(newPaper)
                self.loading = false
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
