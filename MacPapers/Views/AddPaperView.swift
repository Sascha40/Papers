//
//  AddPaperView.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

enum ActiveAlert {
    case success, error, notSigned
}

struct AddPaperView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @EnvironmentObject var papers: PapersViewModel
    @EnvironmentObject var categories: PaperCategoryViewModel
    
    @State private var selectedCategory =  3
    @State private var name:String = ""
    @State private var description:String = ""
    @State private var expirationDate:Date = Date()
    @State private var showRectoActionSheet:Bool = false
    @State private var showVersoActionSheet:Bool = false
    @State private var showRectoImagePickerView:Bool = false
    @State private var showVersoImagePickerView:Bool = false
    @State private var showFormAlert = false
    @State private var showLoadingView = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var rectoImage: NSImage? = NSImage(named: "recto")
    @State private var versoImage: NSImage? = NSImage(named: "verso")
    @State private var sourceType: Int = 0
    @State private var newPaper = Paper(name: "", userDescription: "", rectoImage: NSImage(named: "ph_recto")!, versoImage: NSImage(named: "ph_verso")!, expirationDate: Date(), addDate: Date())
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView{
                    HStack {
                        Text("Remplissez ce formulaire pour ajouter un paper")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    VStack {
                        HStack {
                            Text("Catégorie")
                                .font(Font.custom("Avenir-black", size: 25))
                                .bold()
                            Spacer()
                        }.padding(.top)
                        
                        Picker(selection: self.$selectedCategory, label: Text("Catégorie")) {
                            ForEach(0 ..< self.categories.paperCategory.count) {
                                Text(self.categories.paperCategory[$0].name)
                            }
                        }
                        .labelsHidden()
                        .frame(height: 120)
                        .clipped()
                        
                        VStack (alignment: .leading) {
                            Text("Informations")
                                .font(Font.custom("Avenir-black", size: 25))
                                .bold()
                                .padding(.top)
                            Text("Nom")
                                .font(.callout)
                                .bold()
                                .padding(.top)
                            TextField("Nom du paper", text: self.$name)
                                .frame(height: 25)
                                .padding(10)
                                .cornerRadius(10)
                            Text("Description").font(.callout).bold()
                            TextField("Description du paper", text: self.$description)
                                .frame(height: 25)
                                .padding(10)
                                .cornerRadius(10)
                            Text("Date d'expiration")
                                .font(.callout)
                                .bold()
                                .padding(.top)
                        }
                        
                        DatePicker(selection: self.$expirationDate, in: Date()..., displayedComponents: .date) {
                            Text("Date d'expiration")
                        }
                        .labelsHidden()
                        .frame(height: 120)
                        .clipped()
                        
                        HStack {
                            Text("Image(s)")
                                .font(Font.custom("Avenir-black", size: 25))
                                .bold()
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 7) {
                            HStack(spacing: 90) {
                                Image(nsImage: self.rectoImage!)
                                    .resizable()
                                    .aspectRatio(self.rectoImage!.size, contentMode: .fill)
                                    .frame(width: 80, height: 60)
                                    .cornerRadius(15)
                            }
                            
                            HStack(spacing: 90) {
                                Image(nsImage: self.versoImage!)
                                    .resizable()
                                    .aspectRatio(self.versoImage!.size, contentMode: .fill)
                                    .frame(width: 80, height: 60)
                                    .cornerRadius(15)

                            }
                        }
                        .padding(.top)
                    }
                    
                    VStack {
                        Button(action: {
                            if !self.name.isEmpty && !self.description.isEmpty {
                                self.showLoadingView = true
                                
                                CloudKitHelper.verifyIfUserIsSignedIn { (result) in
                                    switch result {
                                    case .success(let value):
                                        self.activeAlert = .notSigned
                                        self.showFormAlert = value
                                        if value == true {
                                            self.showLoadingView = false
                                        }
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                    }
                                }
                                
                                self.papers.papers.removeAll()
                                CloudKitHelper.fetchPaper { (result) in
                                    switch result {
                                    case .success(let newPaper):
                                        self.papers.papers.append(newPaper)
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                    }
                                }
                                
                                let newPaper = Paper(name: self.name, userDescription: self.description, rectoImage: self.rectoImage!, versoImage: self.versoImage!, expirationDate: self.expirationDate, addDate: Date(), category: self.categories.paperCategory[self.selectedCategory])
                                
                                CloudKitHelper.savePaper(paper: newPaper) { (result) in
                                    switch result {
                                    case .success(let newPaper):
                                        print("NewPAPER :  \(newPaper)")
                                        self.papers.papers.insert(newPaper, at: 0)
                                        self.activeAlert = .success
                                        self.showLoadingView = false
                                        self.showFormAlert = true
                                        self.name = ""
                                        self.description = ""
                                        self.selectedCategory = self.categories.paperCategory.count/2
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                        print(error)
                                    }
                                }
                            } else {
                                self.activeAlert = .error
                                self.showFormAlert = true
                            }
                        }) {
                            HStack {
                                Text("Ajouter").bold()
                            }
                            .alert(isPresented: self.$showFormAlert) {
                                switch self.activeAlert {
                                case .error:
                                    return Alert(title: Text("Pas si vite 😱"), message: Text("Remplissez correctement tous les champs"),
                                                 dismissButton: .default(Text("Ok")))
                                case .success:
                                    return Alert(title: Text("C'est un succès ! 🎉"), message: Text("Votre paper à bien été ajouté"),
                                                 dismissButton: .default(Text("Ok")))
                                case .notSigned:
                                    return Alert(title: Text("Vous n'êtes pas connecté à icloud 🧐"), message: Text("Connectez vous à iCloud pour enregistrer des papers. Pour cela ouvrez l’app Réglages > Se connecter à (appareil) puis identifiez-vous"),
                                                 dismissButton: .default(Text("Ok")))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding([.leading, .trailing])
            }
            .onAppear {
                self.rectoImage = NSImage(named: "recto")!
                self.versoImage = NSImage(named: "verso")!
            }
        }
    }
}




struct AddPaperView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaperView()
    }
}
