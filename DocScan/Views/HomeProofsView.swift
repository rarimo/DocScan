//
//  HomeProofsView.swift
//  DocScan
//
//  Created by Ivan Lele on 06.02.2024.
//

import SwiftUI

struct HomeProofsView: View {
    @Binding var scanData: [ScanData]
    
    var body: some View {
        VStack {
            HStack {
                Text("Proofs")
                    .bold()
                    .font(.system(size: 35))
                    .padding()
                Spacer()
            }
            if scanData.count != 0 {
                ZStack {
                    Color.white
                        .shadow(radius: 1, y: 1)
                    List {
                        ForEach(scanData, id: \.self) {scanData in
                            ProofItemView(scanData: scanData)
                                .listRowSeparator(.hidden)
                                .frame(height: 37)
                        }
                        .onDelete { atOffsets in
                            scanData.remove(atOffsets: atOffsets)
                            ScanData.saveDataBatch(scanData)
                        }
                    }
                    .listStyle(.plain)
                }
                .frame(width: 342, height: 173)
            }
            if scanData.count == 0 {
                HStack {
                    Text("EmptyProofs")
                        .opacity(0.5)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeProofsView(
        scanData: .constant(ScanData.sampleData)
    )
}
