//
//  AnimatedButtonView.swift
//  Papers
//
//  Created by Sascha Sallès on 25/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .font(Font.custom("Avenir-black", size: 17))
            .padding(configuration.isPressed ?  13 : 12)
            .background(configuration.isPressed ? Color(red: 110/255, green: 203/255, blue: 200/255) : Color(hex: "#82c6cf"))
            .cornerRadius(configuration.isPressed ? 30 : 25)
            .scaleEffect(configuration.isPressed ? 1.5 : 1.0)
    }
}

