//
//  CloudKitHelper.swift
//  Papers
//
//  Created by Sascha Sallès on 22/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

struct CloudKitHelper {
    
    struct RecordType {
        static let Paper = "Paper"
        static let PaperCategory = "PaperCategory"
    }
    
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIdFailure
        case castFailure
        case cursorFailure
    }
    
    /* Fonction Save
     @escaping signifie que quand une closure est passé en argument de fonction elle reste en mémoire même après l'éxecution. Utile pour l'asynchrone.
     */
    
    //    static func save(paper: Paper, completion: @escaping(Result<Paper, Error>) ->Void) {
    //        let paperRecord = CKRecord(recordType: RecordType.Paper)
    //
    //        let paperRectoImageData: NSData = NSData(data: paper.rectoImage.pngData()!)
    //        let paperVersoImageData: NSData = NSData(data: paper.versoImage.pngData()!)
    //
    //        paperRecord["name"] = paper.name as CKRecordValue
    //        paperRecord["addDate"] = paper.addDate as CKRecordValue
    //        paperRecord["userDescription"] = paper.userDescription as CKRecordValue
    //        paperRecord["expirationDate"] = paper.expirationDate as CKRecordValue
    //        paperRecord["rectoImage"] = paperRectoImageData as CKRecordValue
    //        paperRecord["versoImage"] = paperVersoImageData as CKRecordValue
    //
    //        CKContainer.default().publicCloudDatabase.save(paperRecord) { (record, err) in
    //            DispatchQueue.main.async {
    //                if let err = err {
    //                    completion(.failure(err))
    //                    return
    //                }
    //                guard let record = record else {
    //                    completion(.failure(CloudKitHelperError.recordFailure))
    //                    return
    //                }
    //                let recordId = record.recordID
    //                guard
    //                    let name = record["name"] as? String,
    //                    let userDescription = record["userDescription"] as? String,
    //                    let addDate = record.creationDate,
    //                    let expirationDate = record["expirationDate"] as? Date,
    //                    let rectoImage = record["rectoImage"] as? CKAsset,
    //                    let versoImage = record["versoImage"] as? CKAsset
    //                    else {
    //                        completion(.failure(CloudKitHelperError.castFailure))
    //                        return
    //                }
    //                let paper = Paper(recordId: recordId, name: name, userDescription: userDescription, rectoImage: rectoImage, versoImage: versoImage, addDate: addDate, expirationDate: expirationDate)
    //                completion(.success(paper))
    //            }
    //        }
    //    }
    
    // Fontion fetchPapers, permet de fetch tous les papers
    
    static func fetchPapers(completion: @escaping(Result<Paper, Error>)  -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Paper, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "userDescription",  "expirationDate" , "rectoImage", "versoImage", "creationDate", "category"]
        operation.resultsLimit = 200
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordId = record.recordID
                guard
                    let name = record["name"] as? String,
                    let userDescription = record["userDescription"] as? String,
                    let category = record["category"] as? CKRecord.Reference,
                    let addDate = record.creationDate,
                    let expirationDate = record["expirationDate"] as? Date,
                    let rectoImage = record["rectoImage"] as? CKAsset,
                    let versoImage = record["versoImage"] as? CKAsset
                    else { return }
                
                guard
                    let rectoFileURL = rectoImage.fileURL,
                    let versoFileURL = versoImage.fileURL
                    else { return}
                
                let rectoImageData: Data
                let versoImageData: Data
                
                do {
                    rectoImageData = try Data(contentsOf: rectoFileURL)
                    versoImageData = try Data(contentsOf: versoFileURL)
                } catch { return }
                
                guard
                    let rectoUIImage = UIImage(data: rectoImageData),
                    let versoUIImage = UIImage(data: versoImageData)
                    else { return }
                
                fetchCategoryById(recordID: category.recordID) { (result) in
                    switch result {
                    case .success(let paperCat):
                        let paper = Paper(recordId: recordId, name: name, userDescription: userDescription, rectoImage: rectoUIImage, versoImage: versoUIImage, expirationDate: expirationDate, addDate: addDate, category: paperCat)
                        completion(.success(paper))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // Fonction fetchPaperCategories, permet de fetch toutes les catégories
    
    static func fetchPaperCategories(completion: @escaping(Result<PaperCategory, Error>)  -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.PaperCategory, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "color"]
        operation.resultsLimit = 200
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordId = record.recordID
                guard let name = record["name"] as? String else { return }
                guard let color = record["color"] as? String else { return }
                let convertedColor = Color(hex: color)
                let paperCategory = PaperCategory(recordId: recordId, name: name, color: convertedColor)
                completion(.success(paperCategory))
            }
        }
        
        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // Fonction fetchCategoryById, permet de fetch une categorie avec son Id
    
    static func fetchCategoryById(recordID: CKRecord.ID, _ completion: @escaping(Result<PaperCategory, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let record = record {
                    let recordId = record.recordID
                    guard let name = record["name"] as? String else { return }
                    guard let color = record["color"] as? String else { return }
                    let convertedColor = Color(hex: color)
                    let paperCategory = PaperCategory(recordId: recordId, name: name, color: convertedColor)
                    completion(.success(paperCategory))
                }
            }
        }
    }
    
    
    
}
