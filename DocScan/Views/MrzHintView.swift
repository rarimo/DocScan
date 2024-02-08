//
//  MrzHintView.swift
//  DocScan
//
//  Created by Ivan Lele on 25.12.2023.
//

import SwiftUI

struct MrzHintView: View {
    @ObservedObject var welcomeController: WelcomeController
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("ScanMrzTitle")
                    .bold()
                    .font(.system(size: 30))
                    .padding()
                    .padding(.leading)
                    .frame(height: 200)
                Spacer()
            }
            Image("ePassport")
                .resizable()
                .frame(width: 350, height: 220)
                .shadow(radius: 5, x: 0, y: 5)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.03)
                    .frame(width: 350, height: 60)
                    .padding()
                HStack {
                    Image("Lightning")
                    Text("ScanMrzHint")
                }
            }
            Spacer()
                .frame(height: 200)
            Button(action: {
                welcomeController.nextStage()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(.lauchScreen)
                        .frame(width: 350, height: 50)
                    Text("Scan")
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .padding(.bottom)
            .padding(.bottom)
            Spacer()
        }
    }
}

#Preview {
    MrzHintView(welcomeController: WelcomeController())
}
