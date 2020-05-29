//
//  MenuRow.swift
//  MacPapers
//
//  Created by Sascha Sallès on 29/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct MenuRow: View {
    var menuItemName: String
    var menuItemLogo: String
    var menuItemDescription: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(menuItemLogo)

            VStack(alignment: .leading) {
                Text(menuItemName)
                    .fontWeight(.bold)
                    .truncationMode(.tail)
                    .frame(minWidth: 20)

                Text(menuItemDescription)
                    .font(.caption)
                    .opacity(0.625)
                    .truncationMode(.middle)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}


