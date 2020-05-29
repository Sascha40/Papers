# Papers (French Project)
> Auteur / Développeur : Sascha Sallès, www.saschasalles.com

## Description du projet

Papers est une application "cross-platform" apple ayant pour but de simplifier la vie des utilisateurs.  
En effet, elle agit comme une sorte de wallet et permet de stocker tous les documents de notre vie courrante.  
De la carte d'identité, au factures, en passant par le permis de conduire, Papers permet de vous organiser et de toujours tout avoir à portée de main.  

## Technologies utilisées

* Framework Front-End : SwiftUI, UIKit, AppKit 
* Framework Back-End :  Core-Data, CloudKit, Combine
* Architecture du projet : MVVM
* Langage : Swift 5
* Logiciel : Xcode 11.4


### Doc Cloudkit

#### Initialisation 

* Avoir un compte développeur apple payé
* Ouvrir cloudkit dashboard
* Créer un container
* Dans xcode ajouter iCloud dans les capabilities (projet > nom du projet > Signin & Capabilities)
* Renseigner un bundle identifier correct
* Activer Background Fetch (pour fetch la data en arrière plan/temps donné)

#### CloudkitHelper (version iOS)

Ceci est la doc d'explication de mon helper pour faire un crud en Cloudkit dans le cadre de se projet.

* Dans Cloudkit, une "table" se nomme un RecordType et un "record" est un champs de la table.
  * J'ai donc créer une struct `RecordType` pour switcher entre les tables.

* J'ai ensuite crée une enum prenant en charge les erreurs cloudkit `enum CloudKitHelperError: Error`

### Récap des fonctions: 
 #### CREATE
  *  `static func savePaper(paper: Paper, completion: @escaping(Result<Paper, Error>) -> Void)`
    * prend un paper en paramètre, renvoie une closure avec un tableau de type Résult qui elle renvoie un paper ou une erreur
 
 
 #### READ / FETCH
  *  `static func fetchPaper(completion: @escaping(Result<Paper, Error>)  -> Void) `
    * renvoie une closure avec un tableau de type Résult qui elle renvoie un paper ou une erreur

  * `static func fetchPaperById(recordID: CKRecord.ID, _ completion: @escaping(Result<Paper, Error>) -> Void)`
    * prend un recordID en parametres, renvoie une closure avec un tableau de type Résult qui elle renvoie un paper ou une erreur
    
  * `static func fetchPaperCategory(completion: @escaping(Result<PaperCategory, Error>)  -> Void)`
    * renvoie une closure avec un tableau de type Résult qui elle renvoie une PaperCategory ou une erreur
    
  * `static func fetchCategoryById(recordID: CKRecord.ID, _ completion: @escaping(Result<PaperCategory, Error>) -> Void)`
    * prend un recordId en paramètre, renvoie une closure avec un tableau de type Résult qui elle renvoie une PaperCategory ou une erreur
    
 #### UPDATE / MODIFY   
   * `static func modifyPaper(paper: Paper, completion: @escaping (Result<Paper, Error>) -> Void)` 
      * prend un paper en parametres, renvoie une closure avec un tableau de type Résult qui elle renvoie le paper modifié ou une erreur
    
 ####  DELETE
 
 * `static func deletePaper(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> Void)`
    * prend un recordId en paramètre, renvoie une closure avec un tableau de type Résult qui elle retourne l'enregistrement supprimé ou une erreur 
 
 #### VERIF DE L'AUTHENTIFICATION
 static func verifyIfUserIsSignedIn(_ completion: @escaping(Result<Bool, Error>) -> Void){
   * renvoie une closure avec un tableau de type Résult qui elle retourne un tableau avec un Bool ou une erreur.

 
 
Ces fonctions sont l'adaptations des fonctions de cloudkit suivantes :
  * `CKContainer.default().privateCloudDatabase.add(operation)`
  * `CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in`
  * `CKContainer.default().privateCloudDatabase.fetch(withRecordID: recordID) { record, err in`
  * `CKContainer.default().accountStatus { (accountStatus, error) in`
