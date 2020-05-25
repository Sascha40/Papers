//
//  EditPaperView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct EditPaperView: View {
    @Binding var isPresented: Bool
    @State private var selectorIndex = 0
    @ObservedObject var categories = PaperCategoryViewModel()
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top){
                    Text("Modifier un paper")
                        .font(Font.custom("Avenir-black", size: 25))
                        .foregroundColor(Color.init(red: 69/255, green: 140/255, blue: 157/255))
                    Spacer()
                    Button(action: { self.isPresented = false}, label:{
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color.init(red: 69/255, green: 140/255, blue: 157/255))
                            .frame(width: 25, height: 25)
                    })
                }
            }
            VStack {
                
                ForEach(self.categories.paperCategory) { category in
                    Text(category.name)
                }
            }
            Spacer()
        }.padding()
    }
}

struct EditPaperView_Previews: PreviewProvider {
    static var previews: some View {
        EditPaperView(isPresented: .constant(true))
    }
}
