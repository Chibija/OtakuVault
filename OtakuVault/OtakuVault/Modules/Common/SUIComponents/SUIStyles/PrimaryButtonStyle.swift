//
//  PrimaryButtonStyle.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/30/23.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(.yellow)
            .foregroundColor(.black)
            .clipShape(Rectangle())
            .padding(.horizontal, 24)
    }
}
