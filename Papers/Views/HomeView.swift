//
//  ContentView.swift
//  Papers
//
//  Created by Sascha Sallès on 22/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI
import CloudKit



struct HomeView: View {
    @ObservedObject  var papers = PapersViewModel()
    @ObservedObject var paperCategory = PaperCategoryViewModel()
    var body: some View {
        LoadingView(isShowing: .constant(self.paperCategory.loading)) {
            NavigationView {
                List(self.paperCategory.paperCategory) { paperCategory in
                    HStack {
                        MenuItemView(color: paperCategory.color, text: paperCategory.name)
                    }
                }
                .navigationBarTitle("Papers")
            }
            .onAppear {UITableView.appearance().separatorColor = .clear}
            .onDisappear{UITableView.appearance().separatorColor = .clear}
        }
    }
}

struct ContentView: View {
    @State var selected = 0
    var body: some View {
        TabView(selection: $selected) {
            HomeView().tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar0)
                    .font(Font.system(size: 20))
                Text("\(Constants.TabBarText.tabBar0)")
            }).tag(0)
            PapersListView().tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar1)
                    .font(Font.system(size: 20))
                Text("\(Constants.TabBarText.tabBar1)")
            }).tag(1)
            AddPaperView().tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar2)
                    .font(Font.system(size: 20))
                Text("\(Constants.TabBarText.tabBar2)")
            }).tag(2)
        }.accentColor(Color(red: 69/255, green: 140/255, blue: 157/255))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
