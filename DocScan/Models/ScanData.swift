//
//  ScanData.swift
//  DScanner
//
//  Created by Ivan Lele on 05.02.2024.
//

import Foundation
import NFCPassportReader
import QKMRZScanner

enum ScanData: Codable, Hashable {
    static let storageKey = "scan_data.batch"
    
    case ePassport(proof: String, publicInputs: String)
    case qr(String)
    case empty
    
    var isEPassport: Bool {
        switch self {
        case .ePassport(
            proof: _,
            publicInputs: _
        ):
            return true
        case .qr(_):
            return false
        case .empty:
            return false
        }
    }
    
    var isQR: Bool {
        switch self {
        case .ePassport(
            proof: _,
            publicInputs: _
        ):
            return false
        case .qr(_):
            return true
        case .empty:
            return false
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .ePassport(
            proof: _,
            publicInputs: _
        ):
            return false
        case .qr(_):
            return false
        case .empty:
            return true
        }
    }
    
    var title: String {
        switch self {
        case .ePassport(
            proof: _,
            publicInputs: _
        ):
            return "Proof of personhood"
        case .qr(_):
            return "Proof of data"
        case .empty:
            return "Empty"
        }
    }
    
    static func fromNfcModel(_ nfcModel: NFCPassportModel) -> Self {
        let dg1 = nfcModel.getDataGroup(.DG1)!.data
        
        let currentYear = Calendar.current.component(.year, from: Date())-2000
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        
        let inputs = PassportInput(
            inKey: Data(dg1).toCircuitInput(),
            currDateYear: currentYear,
            currDateMonth: currentMonth,
            currDateDay: currentDay,
            credValidYear: currentYear+1,
            credValidMonth: currentMonth,
            credValidDay: currentDay,
            ageLowerbound: 18
        )
        
        let inputsJson = try! JSONEncoder().encode(inputs)
        
        let witness = try! ZKUtils.calcWtnsPassportVerificationSHA256(inputsJson: inputsJson)
        
        let (proof, publicInputs) = try! ZKUtils.groth16PassportVerificationSHA256Prover(wtns: witness)
        
        return .ePassport(
            proof: String(data: proof, encoding: .utf8)!,
            publicInputs: String(data: publicInputs, encoding: .utf8)!
        )
    }
    
    static func getDataBatch() -> [Self] {
        guard let rawData = UserDefaults.standard.value(forKey: Self.storageKey) as? Data else {
            return []
        }
        
        guard let data = try? JSONDecoder().decode([Self].self, from: rawData) else {
            return []
        }
        
        return data
    }
    
    static func saveDataBatch(_ data: [Self]) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: Self.storageKey)
        }
    }
    
    static func eraceDataBatch() {
        UserDefaults.standard.removeObject(forKey: Self.storageKey)
    }
    
    static let sampleData: [Self] = [
        Self.ePassport(
           proof: "proof", publicInputs: "publicInputs"
        ),
        Self.qr("https://example.com/")
    ]
    
    func toJSON() -> String {
        return String(data: try! JSONEncoder().encode(self), encoding: .utf8)!
    }
}

extension Data {
    func toCircuitInput() -> [UInt8] {
        var circuitInput = Data()
        
        for byte in self {
            circuitInput.append(contentsOf: byte.bits())
        }
        
        return [UInt8](circuitInput)
    }
}

extension UInt8 {
    func bits() -> [UInt8] {
        var byte = self
        var bits = [UInt8](repeating: .zero, count: 8)
        for i in 0..<8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = 1
            }

            byte >>= 1
        }

        return bits.reversed()
    }
}

struct PassportInput: Codable {
    let inKey: [UInt8]
    let currDateYear: Int
    let currDateMonth: Int
    let currDateDay: Int
    let credValidYear: Int
    let credValidMonth: Int
    let credValidDay: Int
    let ageLowerbound: Int
    
    private enum CodingKeys: String, CodingKey {
        case inKey = "in", currDateYear, currDateMonth, currDateDay, credValidYear, credValidMonth, credValidDay, ageLowerbound
    }
}
