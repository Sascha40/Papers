//
//  PaperCategory.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit

struct PaperCategory: Identifiable, Hashable {
    var id = UUID()
    var recordId: CKRecord.ID?
    var name: String
    var color: Color
    var logo: String
}
    
    



