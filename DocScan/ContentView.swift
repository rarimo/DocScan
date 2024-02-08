//
//  ContentView.swift
//  DocScan
//
//  Created by Ivan Lele on 25.12.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var welcomeController = WelcomeController()
    
    var body: some View {
        ZStack {
            if welcomeController.isAutorized {
                MainView(welcomeController: welcomeController)
            }
            
            if !welcomeController.isAutorized {
                WelcomeView(welcomeController: welcomeController)
            }
        }
        .environment(\.locale, .init(identifier: welcomeController.localization))
    }
}

#Preview {
    ContentView()
}
