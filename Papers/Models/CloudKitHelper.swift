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
//        paperRecord["name"] = paper.name as CKRecordValue
//        paperRecord["addDate"] = paper.addDate! as CKRecordValue
//        paperRecord["userDescription"] = paper.userDescription as CKRecordValue
//        paperRecord["category"] = paper.category! as CKRecord.Reference
//        paperRecord["expirationDate"] = paper.expirationDate! as CKRecordValue
//        paperRecord["rectoImage"] = paper.rectoImage! as CKAsset
//        paperRecord["versoImage"] = paper.versoImage as CKAsset?
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
//                    let addDate = record["addDate"] as? NSDate,
//                    let category = record["category"] as? CKRecord.Reference,
//                    let expirationDate = record["expirationDate"] as? NSDate,
//                    let rectoImage = record["rectoImage"] as? CKAsset,
//                    let versoImage = record["versoImage"] as? CKAsset
//                    else {
//                    completion(.failure(CloudKitHelperError.castFailure))
//                    return
//                }
//                let paper = Paper(recordId: recordId, name: name, userDescription: userDescription, rectoImage: rectoImage, versoImage: versoImage, addDate: addDate, expirationDate: expirationDate, category: category)
//                completion(.success(paper))
//            }
//        }
//    }
    
    static func fetch(completion: @escaping(Result<Paper, Error>)  -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Paper, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "userDescription", "addDate",  "expirationDate" , "rectoImage" /*, "category", "rectoImage", "versoImage"*/]
        operation.resultsLimit = 200
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordId = record.recordID
                guard
                   let name = record["name"] as? String,
                   let userDescription = record["userDescription"] as? String,
                   let addDate = record["addDate"] as? Date,
//                   let category = record["category"] as? CKRecord.Reference,
                   let expirationDate = record["expirationDate"] as? Date,
                   let rectoImage = record["rectoImage"] as? CKAsset
//                   let versoImage = record["versoImage"] as? CKAsset
                   else { return }
                
                guard
                  let fileURL = rectoImage.fileURL
                  else {
                    return
                }
                let imageData: Data
                do {
                    imageData = try Data(contentsOf: fileURL)
                } catch {
                    return
                }
                guard
                  let image = UIImage(data: imageData)
                    else { return }
                    
                let paper = Paper(recordId: recordId, name: name, userDescription: userDescription, rectoImage: image, addDate: addDate, expirationDate: expirationDate)
                /* versoImage: versoImage, addDate: addDate, expirationDate: expirationDate, category: category*/
                completion(.success(paper))
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
    
    
    
    
    
    
}
