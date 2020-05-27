//
//  Background.swift
//  Papers
//
//  Created by Sascha Sallès on 26/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//
import SwiftUI

struct Background<Content> :View where Content: View  {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}


