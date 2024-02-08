//
//  NfcView.swift
//  DocScan
//
//  Created by Ivan Lele on 25.12.2023.
//

import SwiftUI

struct NfcView: View {
    @ObservedObject var welcomeController: WelcomeController
    
    var body: some View {
        VStack {
            Text("NFCScan")
                .bold()
                .font(.system(size: 25))
                .padding()
            ZStack {
                Image("PassportCover")
                    .resizable()
                    .frame(width: 153, height: 174)
                ZStack {
                    Image("Phone")
                        .resizable()
                        .frame(width: 98, height: 192.2)
                    Image("NFC")
                        .resizable()
                        .frame(width: 79, height: 61)
                }
                .padding(.leading)
                .padding(.leading)
                .padding(.leading)
                .padding(.leading)
                .padding(.leading)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .padding(.top)
            }
            Text("NFCHint")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    NfcView(welcomeController: WelcomeController())
}
