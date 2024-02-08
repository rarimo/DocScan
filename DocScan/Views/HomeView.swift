//
//  HomeView.swift
//  DocScan
//
//  Created by Ivan Lele on 26.12.2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var welcomeController: WelcomeController
    @ObservedObject var homeController: HomeController
    
    @State var scanData = ScanData.getDataBatch()
    
    @State var isQrScanActive = false
    @State var isDocScanActive = false
    
    var body: some View {
        ZStack {
            if !isQrScanActive {
                Color.background2
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        LocalizationSwitcherView(welcomeController: welcomeController)
                            .padding()
                    }
                    HomeProofsView(scanData: $scanData)
                    HomeScanView(onQrScan: onQrScan, onDocScan: onDocScan)
                        .offset(y: 100)
                    Spacer()
                    SecureView()
                }
                if welcomeController.nfcScannerController.nfcModel != nil {
                    DataRetrivedPassportView(nfcModel: welcomeController.nfcScannerController.nfcModel!) {
                        let newScanData = ScanData.fromNfcModel(welcomeController.nfcScannerController.nfcModel!)
                        
                        welcomeController.nfcScannerController.nfcModel = nil
                        
                        isDocScanActive = false
                        
                        welcomeController.currentStage = .off
                        
                        if scanData.contains(newScanData)  {
                            return
                        }
                        
                        self.scanData.append(newScanData)
                        ScanData.saveDataBatch(scanData)
                    }
                }
            }
            if isDocScanActive {
                RegisterView(isDocScanActive: $isDocScanActive, welcomeController: welcomeController) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isDocScanActive = false
                        welcomeController.currentStage = .off
                    }
                }
            }
        }
    }
    
    func onQrScan() {
        isQrScanActive = true
    }
    
    func onDocScan() {
        isDocScanActive = true
        welcomeController.nextStage()
    }
}

#Preview {
    HomeView(
        welcomeController: WelcomeController(),
        homeController: HomeController()
    )
}
