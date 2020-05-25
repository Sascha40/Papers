//
//  AddPaperView.swift
//  Papers
//
//  Created by Sascha Sallès on 24/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct AddPaperView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @ObservedObject var categories = PaperCategoryViewModel()
    @State var selectedCategory =  2
    @State private var name:String = ""
    @State private var description:String = ""
    @State var expirationDate:Date = Date()
    @State var showRectoActionSheet:Bool = false
    @State var showVersoActionSheet:Bool = false
    @State var showRectoImagePickerView:Bool = false
    @State var showVersoImagePickerView:Bool = false
    @State var rectoImage: Image?
    @State var versoImage: Image?
    @State var sourceType: Int = 0
    
    var body: some View {
        LoadingView(isShowing: .constant(self.categories.loading)) {
            NavigationView {
                
                ZStack {
                    ScrollView(showsIndicators: false) {
                        
                        HStack {
                            Text("Remplissez ce formulaire pour ajouter un paper")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                Text("Type")
                                    .font(Font.system(size: 25))
                                    .bold()
                                Spacer()
                            }.padding(.top)
                            
                            Picker(selection: self.$selectedCategory, label: Text("Type")) {
                                ForEach(0 ..< self.categories.paperCategory.count) {
                                    Text(self.categories.paperCategory[$0].name)
                                }
                            }
                            .labelsHidden()
                            .frame(height: 120)
                            .clipped()
                            
                            VStack (alignment: .leading) {
                                
                                Text("Informations")
                                    .font(Font.system(size: 25))
                                    .bold()
                                    .padding(.top)
                                
                                Text("Nom")
                                    .font(.callout)
                                    .bold()
                                    .padding(.top)
                                
                                TextField("Nom du paper", text: self.$name)
                                    .frame(height: 25)
                                    .padding(10)
                                    .background(Color.init(UIColor.systemGray6))
                                    .cornerRadius(10)
                                
                                Text("Description").font(.callout).bold()
                                
                                TextField("Description du paper", text: self.$description)
                                    .frame(height: 25)
                                    .padding(10)
                                    .background(Color.init(UIColor.systemGray6))
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
                                    .font(Font.system(size: 25))
                                    .bold()
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 7) {
                                HStack(spacing: 90) {
                                    Button(action: {self.showRectoActionSheet.toggle()}, label: {
                                        Text("Selectionner")
                                    })
                                    self.rectoImage?
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 60)
                                        .scaledToFill()
                                        .cornerRadius(15)
                                    
                                        .actionSheet(isPresented: self.$showRectoActionSheet) { () -> ActionSheet in
                                            ActionSheet(title: Text("Selectionnez une image"), message:
                                                Text("Choisissez une image de votre galerie ou prenez une photo"),
                                                        buttons: [
                                                            ActionSheet.Button.default(Text("Appareil Photo"), action: {
                                                                self.sourceType = 0
                                                                self.showRectoImagePickerView.toggle()
                                                            }),
                                                            ActionSheet.Button.default(Text("Galerie"), action: {
                                                                self.sourceType = 1
                                                                self.showRectoImagePickerView.toggle()
                                                            }),
                                                            ActionSheet.Button.cancel(Text("Annuler")),
                                            ])
                                        }
                                    }
                                
                                
                                HStack(spacing: 90) {
                                    Button(action: {self.showVersoActionSheet.toggle()}, label: {
                                        Text("Selectionner")
                                    })
                                    
                                    self.versoImage?
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 60)
                                        .scaledToFill()
                                        .cornerRadius(15)
                                    
                                    .actionSheet(isPresented: self.$showVersoActionSheet) { () -> ActionSheet in
                                        ActionSheet(title: Text("Selectionnez une image"), message:
                                            Text("Choisissez une image de votre galerie ou prenez une photo"),
                                                    buttons: [
                                                        ActionSheet.Button.default(Text("Appareil Photo"), action: {
                                                            self.sourceType = 0
                                                            self.showVersoImagePickerView.toggle()
                                                        }),
                                                        ActionSheet.Button.default(Text("Galerie"), action: {
                                                            self.sourceType = 1
                                                            self.showVersoImagePickerView.toggle()
                                                        }),
                                                        ActionSheet.Button.cancel(Text("Annuler")),
                                        ])
                                    }
                                }
                                    
                                    
                                    
                                    
                                    

                                

                            }
                                
                            .padding(.top)
                        }
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing])
                    
                    if self.showRectoImagePickerView {
                        ImagePickerView(isVisible: self.$showRectoImagePickerView, image: self.$rectoImage, sourceType: self.sourceType)
                    }
                    if self.showVersoImagePickerView {
                        ImagePickerView(isVisible: self.$showVersoImagePickerView, image: self.$versoImage, sourceType: self.sourceType)
                    }
                }
                .onAppear {
                    self.rectoImage = Image("ph_recto")
                    self.versoImage = Image("ph_verso")
                }
                .navigationBarTitle("Ajouter")
            }
        }
    }
}

struct AddPaperView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaperView()
    }
}
