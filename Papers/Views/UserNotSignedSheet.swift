//
//  UserNotSignedSheet.swift
//  Papers
//
//  Created by Sascha Sallès on 28/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct UserNotSignedSheet: View {

    var body: some View {
        
        VStack {
            
            HStack {
                Image(systemName: "doc.on.doc.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
                Text("Bienvenue sur Papers 🎉")
                    .font(Font.custom("Avenir-black", size: 22))
                Spacer()
            }.padding()
                .foregroundColor(Color(hex:"#82c6cf"))
            Spacer()
            VStack {
                HStack {
                    Text("Connection à un compte iCloud")
                        .bold()
                        .padding([.bottom, .top])
                    Image(systemName: "icloud.fill")
                        .foregroundColor(Color(hex:"#82c6cf"))
                }
                Text("Nous n'enregistrons aucune de vos données")
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex:"#82c6cf"))
                    .padding([.trailing, .leading], 5)
                    .padding([.top])
                Text("Celles-ci sont uniquement stockées sur votre compte personnel iCloud nécessaire au bon fonctionnement de l'application.")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Avenir", size: 16))
                    .padding()
                
                Text(" ☀️ Ouvrez l’app Réglages. \n ☀️ Touchez Se connecter à (appareil). \n ☀️ Identifiez vous \n ☀️ Activez iCloud Drive \n")
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Avenir", size: 17))
                
                Text("Si vous n'avez pas de compte iCloud créez-en un")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Avenir", size: 13))
                    .foregroundColor(.secondary)
                    .padding()
                    
                    .padding(3)
            }.padding(.top)

            Spacer()
        }
    }
}

struct UserNotSignedSheet_Previews: PreviewProvider {
    static var previews: some View {
        UserNotSignedSheet()
    }
}
