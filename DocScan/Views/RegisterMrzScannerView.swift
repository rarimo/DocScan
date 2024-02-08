//
//  RegisterMrzScannerView.swift
//  DocScan
//
//  Created by Ivan Lele on 31.01.2024.
//

import SwiftUI

struct RegisterMrzScannerView: View {
    @ObservedObject var mrzScannerController: MRZScannerController
    
    var body: some View {
        VStack {
            HStack {
                Text("ScanPassportCover")
                    .bold()
                    .font(.system(size: 30))
                    .padding(.leading)
                    .padding(.top)
                Spacer()
            }
            .padding(.top)
            .padding(.top)
            .padding(.top)
            ZStack {
                MRZScannerView(mrtScannerController: mrzScannerController)
                    .mask {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 380, height: 300)
                    }
                Image("Passport")
                    .resizable()
                    .frame(width: 380, height: 300)
            }
            .frame(height: 400)
            Spacer()
            SecureView()
        }
        .onAppear {
            mrzScannerController.startScanning()
        }
    }
}

#Preview {
    RegisterMrzScannerView(mrzScannerController: MRZScannerController())
}
