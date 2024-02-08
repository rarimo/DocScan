//
//  LocalizationSwitcherView.swift
//  DocScan
//
//  Created by Ivan Lele on 31.01.2024.
//

import SwiftUI

struct LocalizationSwitcherView: View {
    @ObservedObject var welcomeController: WelcomeController
    
    var body: some View {
        Button(action: {
            welcomeController.switchLocalization()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.15)
                Text("Country")
                    .bold()
                    .opacity(0.5)
            }
        }
        .frame(width: 55, height: 35)
        .buttonStyle(.plain)
    }
}

#Preview {
    LocalizationSwitcherView(welcomeController: WelcomeController())
}
