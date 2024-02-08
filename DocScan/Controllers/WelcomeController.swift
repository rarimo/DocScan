//
//  WelcomeController.swift
//  DocScan
//
//  Created by Ivan Lele on 25.12.2023.
//

import SwiftUI

class WelcomeController: ObservableObject {
    @Published var isAutorized = false

    @Published var currentStage: Stage = .off
    @Published var mrzScannerController = MRZScannerController()
    @Published var nfcScannerController = NFCScannerController()
    
    var onScanned: () -> Void = { }
    
    @Published var localization = Locale.current.identifier == "ru_US" ? "ru" : "en"
    
    init() {
        mrzScannerController.setOnScanned { scanResult in
            self.nextStage()
        }
        
        nfcScannerController.setOnScanned {
            self.onScanned()
        }
        
        nfcScannerController.setOnError {
            self.previousStage()
        }
    }
    
    func setOnScanned(newOnScanned: @escaping () -> Void) {
        onScanned = newOnScanned
    }
    
    func nextStage() {
        switch currentStage {
        case .off:
            currentStage = .mrzHint
        case .mrzHint:
            currentStage = .mrz
        case .mrz:
            currentStage = .nfc
        case .nfc:
            currentStage = .proof
        case .proof:
            currentStage = .finished
        case .finished:
            currentStage = .finished
        }
    }
    
    func previousStage() {
        switch currentStage {
        case .off:
            currentStage = .off
        case .mrzHint:
            currentStage = .off
        case .mrz:
            currentStage = .mrzHint
        case .nfc:
            currentStage = .mrz
        case .proof:
            currentStage = .nfc
        case .finished:
            currentStage = .finished
        }
    }
    
    func verify() {
        DispatchQueue.main.async {
            self.currentStage = .off
        }
    }
    
    enum Stage {
        case off
        case mrzHint
        case mrz
        case nfc
        case proof
        case finished
    }
    
    
    var isOff: Bool {
        return currentStage == .off
    }
    
    var isMrzHint: Bool {
        return currentStage == .mrzHint
    }
    
    var isMrz: Bool {
        return currentStage == .mrz
    }
    
    var isNfc: Bool {
        return currentStage == .nfc
    }
    
    var isProof: Bool {
        return currentStage == .proof
    }
    
    
    var isFinished: Bool {
        return currentStage == .finished;
    }
    
    func switchLocalization() {
        switch self.localization {
        case "ru":
            self.localization = "en"
        case "en":
            self.localization = "ru"
        default:
            self.localization = "ru"
        }
    }
}
