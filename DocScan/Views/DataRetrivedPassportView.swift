//
//  DataRetrivedPassportView.swift
//  DocScan
//
//  Created by Ivan Lele on 06.02.2024.
//

import SwiftUI
import NFCPassportReader

struct DataRetrivedPassportView: View {
    let nfcModel: NFCPassportModel
    
    let onGenerate: () -> Void
    
    @State var isHidden = false
    
    init(nfcModel: NFCPassportModel, onGenerate: @escaping () -> Void) {
        self.nfcModel = nfcModel
        self.onGenerate = onGenerate
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack {
                    Text("DataAnon")
                        .font(.system(size: 35))
                        .bold()
                        .padding()
                    Spacer()
                }
                VStack {
                    HStack {
                        Text("DocumentNumber")
                            .font(.custom("RobotoMono-Regular", size: 15))
                            .opacity(0.5)
                        Spacer()
                        Text(nfcModel.documentNumber)
                            .bold()
                            .font(.custom("RobotoMono-Medium", size: 15))
                    }
                    .padding(.bottom)
                    HStack {
                        Text("DateOfExpiry")
                            .font(.custom("RobotoMono-Regular", size: 15))
                            .opacity(0.5)
                        Spacer()
                        Text(nfcModel.documentExpiryDate)
                            .bold()
                            .font(.custom("RobotoMono-Medium", size: 15))
                    }
                    .padding(.bottom)
                    HStack {
                        Text("Birthday")
                            .font(.custom("RobotoMono-Regular", size: 15))
                            .opacity(0.5)
                        Spacer()
                        Text(nfcModel.dateOfBirth)
                            .bold()
                            .font(.custom("RobotoMono-Medium", size: 15))
                    }
                    .padding(.bottom)
                    HStack {
                        Text("Surname")
                            .font(.custom("RobotoMono-Regular", size: 15))
                            .opacity(0.5)
                        Spacer()
                        Text(nfcModel.lastName)
                            .bold()
                            .font(.custom("RobotoMono-Medium", size: 15))
                    }
                    .padding(.bottom)
                    HStack {
                        Text("GivenName")
                            .font(.custom("RobotoMono-Regular", size: 15))
                            .opacity(0.5)
                        Spacer()
                        Text(nfcModel.firstName)
                            .bold()
                            .font(.custom("RobotoMono-Medium", size: 15))
                    }
                    .padding(.bottom)
                    HStack {
                        Text("Nationality")
                            .font(.custom("RobotoMono-Regular", size: 15))
                            .opacity(0.5)
                        Spacer()
                        Text(nfcModel.nationality)
                            .bold()
                            .font(.custom("RobotoMono-Medium", size: 15))
                    }
                    .padding(.bottom)
                }
                .padding()
                Spacer()
                Button(action: {
                    isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onGenerate()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.lauchScreen)
                        Text("CreateProfile")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
                .frame(width: 326, height: 48)
                .hidden(isHidden)
                if isHidden {
                    Image(systemName: "clock")
                }
            }
        }
    }
}

#Preview {
    DataRetrivedPassportView(nfcModel: NFCPassportModel()) {}
}
