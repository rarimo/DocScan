//
//  NFCScannerController.swift
//  DocScan
//
//  Created by Ivan Lele on 27.12.2023.
//

import SwiftUI
import NFCPassportReader
import OpenSSL

class NFCScannerController: ObservableObject {
    var nfcModel: NFCPassportModel?
    
    var onScanned: () -> Void = {}
    var onError: () -> Void = {}
    
    func setOnScanned(newOnScanned: @escaping () -> Void) {
        onScanned = newOnScanned
    }
    
    func setOnError(newOnError: @escaping () -> Void) {
        onError = newOnError
    }
    
    func read(_ mrzKey: String)  {
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            do {
                try await self._read(mrzKey)
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.onError()
                }
            }
            
            semaphore.signal()
        }

        semaphore.wait()
    }
    
    private func _read(_ mrzKey: String) async throws {
        let newNfcModel = try await PassportReader().readPassport(mrzKey: mrzKey, tags: [.DG1, .DG2, .SOD]);
        
        try validateNfcModel(nfcModel: newNfcModel)
        
        nfcModel = newNfcModel
        
        KeychainUtils.saveNfcModelData(newNfcModel.getDataGroupsRead())
        
        DispatchQueue.main.async {
            self.onScanned()
        }
    }
    
    private func validateNfcModel(nfcModel: NFCPassportModel) throws {
        let expiryDate = nfcModel.documentExpiryDate
        
        let expiryDateStartYearIndex = expiryDate.startIndex
        let expiryDateEndYearIndex = expiryDate.index(expiryDateStartYearIndex, offsetBy: 1)
        
        let expiryDateStartMonthIndex = expiryDate.index(expiryDateEndYearIndex, offsetBy: 1)
        let expiryDateEndMonthIndex = expiryDate.index(expiryDateStartMonthIndex, offsetBy: 1)
        
        let expiryDateStartDayIndex = expiryDate.index(expiryDateEndMonthIndex, offsetBy: 1)
        let expiryDateEndDayIndex = expiryDate.index(expiryDateStartDayIndex, offsetBy: 1)
        
        let expiryYearStr = String(nfcModel.documentExpiryDate[expiryDateStartYearIndex...expiryDateEndYearIndex])
        let expiryMonthStr = String(nfcModel.documentExpiryDate[expiryDateStartMonthIndex...expiryDateEndMonthIndex])
        let expiryDayStr = String(nfcModel.documentExpiryDate[expiryDateStartDayIndex...expiryDateEndDayIndex])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        
        let expiryDateT = dateFormatter.date(from: "20\(expiryYearStr)-\(expiryMonthStr)-\(expiryDayStr)")!
        if Date().timeIntervalSince1970 > expiryDateT.timeIntervalSince1970 {
            throw "Passport is expired"
        }
    }
    
    static func getX509CertificatesFromPKCS7(pkcs7Der: Data ) throws -> [X509Wrapper] {
        guard let inf = BIO_new(BIO_s_mem()) else { throw OpenSSLError.UnableToGetX509CertificateFromPKCS7("Unable to allocate input buffer") }
        defer { BIO_free(inf) }
        let _ = pkcs7Der.withUnsafeBytes { (ptr) in
            BIO_write(inf, ptr.baseAddress?.assumingMemoryBound(to: Int8.self), Int32(pkcs7Der.count))
        }
        guard let p7 = d2i_PKCS7_bio(inf, nil) else { throw OpenSSLError.UnableToGetX509CertificateFromPKCS7("Unable to read PKCS7 DER data") }
        defer { PKCS7_free(p7) }
        
        var certs : OpaquePointer? = nil
        let i = OBJ_obj2nid(p7.pointee.type);
        switch (i) {
            case NID_pkcs7_signed:
                if let sign = p7.pointee.d.sign {
                    certs = sign.pointee.cert
                }
                break;
            case NID_pkcs7_signedAndEnveloped:
                if let signed_and_enveloped = p7.pointee.d.signed_and_enveloped {
                    certs = signed_and_enveloped.pointee.cert
                }
                break;
            default:
                break;
        }
        
        var ret = [X509Wrapper]()
        if let certs = certs  {
            let certCount = sk_X509_num(certs)
            for i in 0 ..< certCount {
                let x = sk_X509_value(certs, i);
                if let x509 = X509Wrapper(with:x) {
                    ret.append( x509 )
                }
            }
        }
        
        return ret
    }
}

extension NFCPassportModel {
    func getDataGroupsRead() -> Data {
        var data: [DataGroupIdOuter: DataGroupOuter] = [:]
        
        for (k, v) in self.dataGroupsRead {
            data[k.toOuter()] = v.toOuter()
        }
        
        return try! JSONEncoder().encode(data)
    }
}

extension DataGroup {
    func toOuter() -> DataGroupOuter {
        DataGroupOuter(body: self.body, data: self.data)
    }
}

struct DataGroupOuter: Codable {
    var body: [UInt8]
    var data: [UInt8]
}

extension DataGroupId {
    func toOuter() -> DataGroupIdOuter {
        return DataGroupIdOuter(rawValue: self.rawValue)!
    }
}

public enum DataGroupIdOuter: Int, CaseIterable, Codable {
    case COM = 0x60
    case DG1 = 0x61
    case DG2 = 0x75
    case DG3 = 0x63
    case DG4 = 0x76
    case DG5 = 0x65
    case DG6 = 0x66
    case DG7 = 0x67
    case DG8 = 0x68
    case DG9 = 0x69
    case DG10 = 0x6A
    case DG11 = 0x6B
    case DG12 = 0x6C
    case DG13 = 0x6D
    case DG14 = 0x6E
    case DG15 = 0x6F
    case DG16 = 0x70
    case SOD = 0x77
    case Unknown = 0x00
    
    func toInner() -> DataGroupId {
        DataGroupId(rawValue: self.rawValue)!
    }
}

struct StorePassport: Codable {
    let PassportBytes: Data
}
