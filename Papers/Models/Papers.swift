//
//  Papers.swift
//  Papers
//
//  Created by Sascha Sallès on 22/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI
import CloudKit
import Foundation

struct Paper: Identifiable {
    var id = UUID()
    var recordId: CKRecord.ID?
    var name: String
    var userDescription: String
    var rectoImage: UIImage
//    var versoImage: CKAsset?
    var addDate: Date
    var expirationDate: Date
//    var category: CKRecord.Reference?
}


class Papers: ObservableObject {
    @Published var papers =  [Paper]()
}
