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
            .padding()
            .background(configuration.isPressed ? Color(red: 110/255, green: 203/255, blue: 200/255) : Color(red: 69/255, green: 140/255, blue: 157/255))
            .cornerRadius(configuration.isPressed ? 20 : 15)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
    }
}

