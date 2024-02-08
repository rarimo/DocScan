//
//  MainView.swift
//  DocScan
//
//  Created by Ivan Lele on 26.12.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var welcomeController: WelcomeController
    @StateObject var homeController = HomeController()
    
    var body: some View {
        ZStack {
            HomeView(
                welcomeController: welcomeController,
                homeController: homeController
            )
        }
    }
}

#Preview {
    MainView(welcomeController: WelcomeController())
}
