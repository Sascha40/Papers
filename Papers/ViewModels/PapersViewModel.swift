
//
//  File.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

class PapersViewModel: ObservableObject {
    @Published var papers =  [Paper]()
    @Published var loading = true
    @Published var sortedPapersByDate = [Paper]()
    
    init() {
        fetchPapers()
        
    }
    
    private func fetchPapers() {
        CloudKitHelper.fetchPaper { (result) in
            switch result {
            case .success(let newPaper):
                self.loading = false
                self.papers.append(newPaper)
            case .failure(let err):
                self.loading = false
                print(err.localizedDescription)
            }
        }
    }

    
    
}
