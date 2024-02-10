//
//  WelcomeView.swift
//  DocScan
//
//  Created by Ivan Lele on 25.12.2023.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var welcomeController: WelcomeController
    
    var body: some View {
        if welcomeController.isOff {
            VStack {
                HStack {
                    Spacer()
                    LocalizationSwitcherView(welcomeController: welcomeController)
                        .padding(.trailing)
                }
                Spacer()
                Image("Logo")
                    .resizable()
                    .frame(width: 113, height: 113)
                Text("DL Doc Scan")
                    .font(.system(size: 25))
                    .bold()
                    .frame(height: 40)
                Text("WelcomeText")
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                    .opacity(0.5)
                    .padding(.bottom)
                    .padding(.bottom)
                ZStack {
                    Rectangle()
                        .opacity(0.03)
                    VStack {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("WelcomeHint1")
                            Spacer()
                        }
                        .opacity(0.5)
                        .padding(.leading)
                        .padding(.bottom)
                        HStack {
                            Image(systemName: "checkmark")
                            Text("WelcomeHint2")
                            Spacer()
                        }
                        .opacity(0.5)
                        .padding(.leading)
                        .padding(.bottom)
                        HStack {
                            Image(systemName: "checkmark")
                            Text("WelcomeHint3")
                            Spacer()
                        }
                        .opacity(0.5)
                        .padding(.leading)
                    }
                }
                .frame(width: 350, height: 160)
                Spacer()
                VStack {
                    Link(destination: URL(string: "https://distributedlab.com/di-polls-pp.html")!) {
                        Text("Privacy policy")
                            .underline()
                    }
                        .underline()
                        .foregroundStyle(.black)
                    Link(destination: URL(string: "https://distributedlab.com/di-polls-tou.html")!) {
                        Text("Terms of use")
                            .underline()
                    }
                        .underline()
                        .foregroundStyle(.black)
                }
                .padding(.bottom)
                Button(action: {
                    welcomeController.isAutorized = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundStyle(.lauchScreen)
                            .frame(width: 350, height: 50)
                        Text("Proceed")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    WelcomeView(welcomeController: WelcomeController())
}
