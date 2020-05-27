//
//  PaperCategoryViewModel.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import Foundation


class PaperCategoryViewModel: ObservableObject {
    @Published var paperCategory = [PaperCategory]()
    @Published var loading = true
    
    init() {
        fetchPaperCategories()
    }
    
    private func fetchPaperCategories(){
        CloudKitHelper.fetchPaperCategory { (result) in
            switch result {
            case .success(let newCategory):
                self.paperCategory.append(newCategory)
                self.loading = false
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
        
}
