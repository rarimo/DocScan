//
//  RegisterView.swift
//  DocScan
//
//  Created by Ivan Lele on 25.12.2023.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isDocScanActive: Bool
    @ObservedObject var welcomeController: WelcomeController
    
    var onScanned: () -> Void = {  }
    
    init(isDocScanActive: Binding<Bool>, welcomeController: WelcomeController, onScanned: @escaping () -> Void) {
        self._isDocScanActive = isDocScanActive
        self.welcomeController = welcomeController
        self.onScanned = onScanned
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            if welcomeController.isMrzHint {
                MrzHintView(welcomeController: welcomeController)
            }
            if welcomeController.isMrz {
                RegisterMrzScannerView(mrzScannerController: welcomeController.mrzScannerController)
            }
            if welcomeController.isNfc {
                NfcView(welcomeController: welcomeController)
                    .onAppear {
                        welcomeController.setOnScanned {
                            self.onScanned()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            welcomeController.nfcScannerController.read(welcomeController.mrzScannerController.mrzKey)
                        }
                    }
            }
            Button(action: {
                isDocScanActive = false
                welcomeController.currentStage = .off
            }) {
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                    Image(systemName: "xmark")
                }
            }
            .buttonStyle(.plain)
            .offset(x: 140, y: -360)
        }
    }
}

#Preview {
    RegisterView(isDocScanActive: .constant(true), welcomeController: WelcomeController()) { }
}
