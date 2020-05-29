//
//  ContentView.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var papers: PapersViewModel
    @EnvironmentObject var paperCategory: PaperCategoryViewModel
    @State private var selectedPaper: Paper?
    @State var showAddPaperView = false
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    List {
                        NavigationLink(destination: PaperListView()) {
                            MenuRow(menuItemName: "Accueil", menuItemLogo: "􀎟", menuItemDescription: "Vue d'ensemble de vos papers")
                        }
                        NavigationLink(destination: PaperListView()) {
                            MenuRow(menuItemName: "Papers", menuItemLogo: "􀉁", menuItemDescription: "Tous vos papers")
                        }
                        NavigationLink(destination: AddPaperView()) {
                            MenuRow(menuItemName: "Ajouter", menuItemLogo: "􀁍", menuItemDescription: "Ajouter un paper")
                        }
                    }.listStyle(SidebarListStyle())
                }.frame(minWidth: 265, maxWidth: 300, minHeight: 700)
            }
        }.frame(minHeight: 700)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
