//
//  CloudKitHelper.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI


struct CloudKitHelper {
    
    @EnvironmentObject  var papers: PapersViewModel
    
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
    
    /* Fonction savePaper, permet de save un paper.
     Retourne une closure qui retourne un résultat détenant une enum avec deux cas Success ou Failure.
     @escaping signifie que quand une closure est passé en argument de fonction elle reste en mémoire même après l'éxecution. Utile pour l'asynchrone.
     */
    
    static func savePaper(paper: Paper, completion: @escaping(Result<Paper, Error>) ->Void) {
        let paperRecord = CKRecord(recordType: RecordType.Paper)
        
        let paperRectoImageData: NSData = NSData(data: paper.rectoImage.tiffRepresentation!)
        let paperVersoImageData: NSData = NSData(data: paper.versoImage.tiffRepresentation!)
        
        guard let paperRectoImageUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") else { return }
        guard let paperVersoImageUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") else { return }
        
        do {
            try paperRectoImageData.write(to: paperRectoImageUrl, options: [])
            try paperVersoImageData.write(to: paperVersoImageUrl, options: [])
        } catch let e as NSError {
            print("Error! \(e)");
            return
        }
        
        paperRecord["name"] = paper.name as CKRecordValue
        paperRecord["addDate"] = paper.addDate as CKRecordValue
        paperRecord["userDescription"] = paper.userDescription as CKRecordValue
        paperRecord["expirationDate"] = paper.expirationDate as CKRecordValue
        paperRecord["rectoImage"] = CKAsset(fileURL: paperRectoImageUrl)
        paperRecord["versoImage"] = CKAsset(fileURL: paperVersoImageUrl)
        if paper.category != nil {
            paperRecord["category"] = CKRecord.Reference(recordID: (paper.category!.recordId)!, action: .none)
        }
        
        CKContainer.default().privateCloudDatabase.save(paperRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let record = record else {
                    completion(.failure(CloudKitHelperError.recordFailure))
                    return
                }
                let recordId = record.recordID
                guard
                    let name = record["name"] as? String,
                    let userDescription = record["userDescription"] as? String,
                    let addDate = record.creationDate,
                    let expirationDate = record["expirationDate"] as? Date,
                    let rectoImage = record["rectoImage"] as? CKAsset,
                    let versoImage = record["versoImage"] as? CKAsset,
                    let category = record["category"] as? CKRecord.Reference
                    else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                }
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
                    let rectoUIImage = NSImage(data: rectoImageData),
                    let versoUIImage = NSImage(data: versoImageData)
                    else { return }
                
                fetchCategoryById(recordID: category.recordID) { (result) in
                    switch result {
                    case .success(let paperCat):
                        let paper = Paper(recordId: recordId, name: name, userDescription: userDescription, rectoImage: rectoUIImage, versoImage: versoUIImage, expirationDate: expirationDate, addDate: addDate, category: paperCat)
                        
                        do {
                            try FileManager.default.removeItem(at: paperRectoImageUrl)
                            try FileManager.default.removeItem(at: paperVersoImageUrl)
                        }
                        catch let error { print("La suppression des fichiers n'a pas aboutie: \(error)") }
                        
                        completion(.success(paper))
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // Fontion fetchPaper, permet de fetch un les paper avec une opération
    
    static func fetchPaper(completion: @escaping(Result<Paper, Error>)  -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Paper, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "userDescription",  "expirationDate" , "rectoImage", "versoImage", "creationDate", "category"]
        operation.resultsLimit = 50
        operation.qualityOfService = .userInteractive
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
                    let rectoUIImage = NSImage(data: rectoImageData),
                    let versoUIImage = NSImage(data: versoImageData)
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
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
    
    // fetchPaperById
    
    static func fetchPaperById(recordID: CKRecord.ID, _ completion: @escaping(Result<Paper, Error>) -> Void) {
        CKContainer.default().privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let record = record {
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
                        let rectoUIImage = NSImage(data: rectoImageData),
                        let versoUIImage = NSImage(data: versoImageData)
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
        }
    }
    
    
    // Fonction fetchPaperCategory, permet de fetch une catégorie avec une opération
    
    static func fetchPaperCategory(completion: @escaping(Result<PaperCategory, Error>)  -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.PaperCategory, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "color", "logo"]
        operation.resultsLimit = 200
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordId = record.recordID
                guard let name = record["name"] as? String else { return }
                guard let color = record["color"] as? String else { return }
                guard let logo = record["logo"] as? String else { return }
                let convertedColor = Color(hex: color)
                let paperCategory = PaperCategory(recordId: recordId, name: name, color: convertedColor, logo: logo)
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
                    guard let logo = record["logo"] as? String else { return }
                    let convertedColor = Color(hex: color)
                    let paperCategory = PaperCategory(recordId: recordId, name: name, color: convertedColor, logo: logo)
                    completion(.success(paperCategory))
                }
            }
        }
    }
    
    // function deletePaper, permet de delete un paper
    
    static func deletePaper(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitHelperError.recordIdFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
    
    // function modifyPaper, permet de modifier un paper
    
    static func modifyPaper(paper: Paper, completion: @escaping (Result<Paper, Error>) -> Void) {
        guard let recordID = paper.recordId else { return }
        CKContainer.default().privateCloudDatabase.fetch(withRecordID: recordID) { record, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitHelperError.recordFailure))
                }
                return
            }
            
            let paperRectoImageData: NSData = NSData(data: paper.rectoImage.tiffRepresentation!)
            let paperVersoImageData: NSData = NSData(data: paper.versoImage.tiffRepresentation!)
           
            
            guard let paperRectoImageUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") else { return }
            guard let paperVersoImageUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") else { return }
            
            do {
                try paperRectoImageData.write(to: paperRectoImageUrl, options: [])
                try paperVersoImageData.write(to: paperVersoImageUrl, options: [])
            } catch let e as NSError {
                print("Error! \(e)");
                return
            }
            
            
            record["name"] = paper.name as CKRecordValue
            record["addDate"] = paper.addDate as CKRecordValue
            record["userDescription"] = paper.userDescription as CKRecordValue
            record["expirationDate"] = paper.expirationDate as CKRecordValue
            record["rectoImage"] = CKAsset(fileURL: paperRectoImageUrl)
            record["versoImage"] = CKAsset(fileURL: paperVersoImageUrl)
            if paper.category != nil {
                record["category"] = CKRecord.Reference(recordID: (paper.category!.recordId)!, action: .none)
            }
            
            CKContainer.default().privateCloudDatabase.save(record) { (record, err) in
                DispatchQueue.main.async {
                    if let err = err {
                        completion(.failure(err))
                        return
                    }
                    guard let record = record else {
                        completion(.failure(CloudKitHelperError.recordFailure))
                        return
                    }
                    let recordID = record.recordID
                    guard
                        let name = record["name"] as? String,
                        let userDescription = record["userDescription"] as? String,
                        let category = record["category"] as? CKRecord.Reference,
                        let addDate = record.creationDate,
                        let expirationDate = record["expirationDate"] as? Date,
                        let rectoImage = record["rectoImage"] as? CKAsset,
                        let versoImage = record["versoImage"] as? CKAsset
                        else {
                            completion(.failure(CloudKitHelperError.castFailure))
                            return
                    }
                    guard let rectoFileURL = rectoImage.fileURL, let versoFileURL = versoImage.fileURL else { return}
                    let rectoImageData: Data
                    let versoImageData: Data
                    do {
                        rectoImageData = try Data(contentsOf: rectoFileURL)
                        versoImageData = try Data(contentsOf: versoFileURL)
                    } catch { return }
                    guard let rectoUIImage = NSImage(data: rectoImageData), let versoUIImage = NSImage(data: versoImageData) else { return }
                    
                    fetchCategoryById(recordID: category.recordID) { (result) in
                        switch result {
                        case .success(let paperCat):
                            let paper = Paper(recordId: recordID, name: name, userDescription: userDescription, rectoImage: rectoUIImage, versoImage: versoUIImage, expirationDate: expirationDate, addDate: addDate, category: paperCat)
                            print("fetched \(paper)")
                            completion(.success(paper))
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    static func verifyIfUserIsSignedIn(_ completion: @escaping(Result<Bool, Error>) -> Void){
        CKContainer.default().accountStatus { (accountStatus, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            if (accountStatus == CKAccountStatus.noAccount) {
                completion(.success(true))
                return
            } else {
                completion(.success(false))
                return
            }
        }
    }
    


}


