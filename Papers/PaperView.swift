//
//  PaperView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperView: View {
    @EnvironmentObject  var papers: Papers
    var body: some View {
        ForEach(papers.papers) { paper in
            Text("\(paper.userDescription)")
        }
    }
}

struct PaperView_Previews: PreviewProvider {
    static var previews: some View {
        PaperView()
    }
}
