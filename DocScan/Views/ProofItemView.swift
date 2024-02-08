//
//  ProofItemView.swift
//  DocScan
//
//  Created by Ivan Lele on 06.02.2024.
//

import SwiftUI

struct ProofItemView: View {
    let scanData: ScanData
    
    @State var copyIcon = "doc.on.doc"
    
    var body: some View {
        HStack {
            Text(scanData.title)
                .bold()
                .font(.system(size: 14))
            Spacer()
            Image(systemName: "checkmark")
        }
    }
}

#Preview {
    ProofItemView(scanData: ScanData.sampleData[0])
}
