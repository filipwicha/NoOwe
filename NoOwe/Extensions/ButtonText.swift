//
//  ButtonText.swift
//  NoOwe
//
//  Created by Filip Wicha on 28/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct ButtonText: View {
    @State var text: String
    
    var body: some View {
        Text(text)
        .fontWeight(.bold)
        .font(.subheadline)
        .padding(EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 12))
        .background(Color.white)
        .cornerRadius(30)
        .foregroundColor(.black)
        .padding(6)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 4)
        )
        .padding(7)
    }
}

struct ButtonText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonText(text: "TEST")
    }
}
