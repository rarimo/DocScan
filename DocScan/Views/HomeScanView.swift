//
//  HomeScanView.swift
//  DocScan
//
//  Created by Ivan Lele on 06.02.2024.
//

import SwiftUI

struct HomeScanView: View {
    let onQrScan: () -> Void
    let onDocScan: () -> Void
    
    init(onQrScan: @escaping () -> Void, onDocScan: @escaping () -> Void) {
        self.onQrScan = onQrScan
        self.onDocScan = onDocScan
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Scan")
                    .bold()
                    .font(.system(size: 35))
                    .padding()
                Spacer()
            }
            Divider()
                .frame(width: 342)
            VStack {
                Button(action: onDocScan) {
                    ZStack {
                        Rectangle()
                            .shadow(radius: 1, y: 1)
                            .foregroundStyle(.white)
                        VStack {
                            HStack {
                                Text("ScanDocument")
                                    .font(.system(size: 14))
                                    .bold()
                                    .padding(.leading)
                                    .offset(y: 15)
                                Spacer()
                            }
                            HStack {
                                Text("DataFromNFC")
                                    .font(.system(size: 12))
                                    .opacity(0.6)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
                .frame(width: 342, height: 89)
                .padding()
            }
        }
    }
}

#Preview {
    HomeScanView(onQrScan: {}, onDocScan: {})
}
