//
//  SecureView.swift
//  DocScan
//
//  Created by Ivan Lele on 31.01.2024.
//

import SwiftUI

struct SecureView: View {
    var body: some View {
        HStack {
            Image(systemName: "lock.shield")
            Text("Secure")
        }
        .opacity(0.5)
    }
}

#Preview {
    SecureView()
}
