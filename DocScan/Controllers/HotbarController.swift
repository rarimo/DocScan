//
//  HotbarController.swift
//  DocScan
//
//  Created by Ivan Lele on 26.12.2023.
//

import SwiftUI

class HotbarController: ObservableObject {
    @Published var currentWindow: Window = .home
    
    enum Window {
        case home
        case qr
        case search
    }
    
    var isHome: Bool {
        return currentWindow == .home
    }
    
    var isQr: Bool {
        return currentWindow == .qr
    }
    
    var isSearch: Bool {
        return currentWindow == .search
    }
    
    func setWindow(_ window: Window) {
        currentWindow = window
    }
}
