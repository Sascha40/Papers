//
//  Paper.swift
//  Paper
//
//  Created by Sascha Sallès on 22/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI
import CloudKit
import Foundation

struct Paper: Hashable, Equatable, Identifiable {
    var id =  UUID()
    var recordId: CKRecord.ID?
    var name: String
    var userDescription: String
    var rectoImage: UIImage
    var versoImage: UIImage
    var expirationDate: Date
    var addDate: Date
    var category: PaperCategory?
}



