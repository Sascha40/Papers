//
//  ContentView.swift
//  Papers
//
//  Created by Sascha Sallès on 22/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @State var selected = 0
    @State var userNotSignedIn: Bool = false
    
    var body: some View {
        TabView(selection: $selected) {
            HomeView(selectedTab: $selected).tabItem({
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
        }.sheet(isPresented: $userNotSignedIn) {
            UserNotSignedSheet()
        }
        .accentColor(Color(hex: "#82c6cf"))
        .onAppear {
            CloudKitHelper.verifyIfUserIsSignedIn { (result) in
                switch result {
                case .success(let value):
                    self.userNotSignedIn = value
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
}



struct HomeView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var papers: PapersViewModel
    @EnvironmentObject var paperCategory: PaperCategoryViewModel
    
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    static let DateComponent: DateComponents = {
        let formatter = DateFormatter()
        var dateComponent = DateComponents()
        dateComponent.day = 10
        return dateComponent
    }()
    
    
    var body: some View {
        LoadingView(isShowing: .constant(self.papers.loading && self.paperCategory.loading)) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Catégories")
                            .font(Font.custom("Avenir-black", size: 20))
                            .padding([.trailing, .leading, .top])
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(self.paperCategory.paperCategory) { paperCategory in
                                        NavigationLink(destination: CategoryView(category: paperCategory)) {
                                            MenuItemView(color: paperCategory.color, text: paperCategory.name, logo: paperCategory.logo)
                                        }
                                    }
                                }.padding([.trailing, .leading])
                            }
                        }
                        .shadow(radius: 4)
                        
                        VStack(alignment: .leading) {
                            Text("Ajoutés récemment")
                                .font(Font.custom("Avenir-black", size: 20))
                                .padding([.trailing, .leading])
                            HStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    if self.papers.papers.count < 3{
                                        HStack {
                                            ForEach(self.papers.papers) { paper in
                                                NavigationLink(destination: PaperView(passedPaper: paper)) {
                                                    PaperItemView(paper: paper)
                                                }.buttonStyle(PlainButtonStyle())
                                            }
                                        }.frame(height: 185)
                                            .padding([.trailing, .leading, .bottom])
                                            .shadow(radius: 3)
                                    } else if self.papers.papers.count/3 < self.papers.papers.count {
                                        HStack {
                                            ForEach(0..<Int(self.papers.papers.count/3), id: \.self) { i in
                                                NavigationLink(destination: PaperView(passedPaper: self.papers.papers[i])) {
                                                    PaperItemView(paper: self.papers.papers[i])
                                                }.buttonStyle(PlainButtonStyle())
                                            }
                                        }.frame(height: 185)
                                            .padding([.trailing, .leading])
                                            .shadow(radius: 3)
                                    } else {
                                        Text("Aucun paper enregistré, ajoutez en un 😊")
                                            .frame(height: 185)
                                            .foregroundColor(Color(hex: "#82c6cf"))
                                            .font(Font.custom("Avenir-black", size: 17))
                                            .padding([.trailing, .leading])
                                        
                                    }
                                }.frame(height: 185)
                            }
                        }.padding(.top)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Expirent dans les 10 prochains jours")
                                .font(Font.custom("Avenir-black", size: 20))

                                ForEach(self.papers.papers.sorted(by: {$0.expirationDate.compare($1.expirationDate) == .orderedAscending}))
                                { paper in
                                    if paper.expirationDate <= Calendar.current.date(byAdding: Self.DateComponent, to: Date())! {
                                    NavigationLink(destination: PaperView(passedPaper: paper)) {
                                        HStack {
                                            Image(uiImage: paper.rectoImage)
                                                .resizable()
                                                .aspectRatio(paper.rectoImage.size, contentMode: .fill)
                                                .frame(width: 90, height:60)
                                                .cornerRadius(7)
                                                .shadow(radius: 3)
                                        
                                            
                                            VStack(alignment: .leading) {
                                                Text(paper.name)
                                                    .font(.headline)
                                                if paper.category != nil {
                                                    HStack {
                                                        Text(paper.category!.name)
                                                            .font(.footnote)
                                                        Spacer()
                                                    }
                                                }
                                                Text( "Expire le \(paper.expirationDate, formatter: Self.taskDateFormat)")
                                                    .font(.subheadline).foregroundColor(.secondary)
                                            }
                                        }
                                    }.buttonStyle(PlainButtonStyle())
                                    }
                                }
                            
                            
                            Spacer()
                        }.padding()
                        
                        Spacer()
                    }
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.selectedTab = 2
                            
                        }) {
                            BadgeView(color: Color(hex: "#82c6cf"), text: "Ajouter", logo: "plus.circle.fill")
                    })
                        .navigationBarTitle("Papers")
                }
            }
        }
    }
}
