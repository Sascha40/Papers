//
//  Paper.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI
import CloudKit
import Foundation

struct Paper: Identifiable, Hashable {
    var id =  UUID()
    var recordId: CKRecord.ID?
    var name: String
    var userDescription: String
    var rectoImage: NSImage
    var versoImage: NSImage
    var expirationDate: Date
    var addDate: Date
    var category: PaperCategory?
}


