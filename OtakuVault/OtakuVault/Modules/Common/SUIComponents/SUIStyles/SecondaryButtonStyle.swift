//
//  SecondaryButtonStyle.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/30/23.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(.black)
            .foregroundColor(.orange)
            .border(.orange, width: 2)
            .clipShape(Rectangle())
            .padding(.horizontal, 24)
    }
}
