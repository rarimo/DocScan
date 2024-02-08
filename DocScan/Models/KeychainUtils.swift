import Foundation
import KeychainAccess

class KeychainUtils {
    static let service = "org.docScanner"
    
    static let nfcModelkey = "nfcModel"
    
    static func saveNfcModelData(_ data: Data) {
        let keychain = Keychain(service: KeychainUtils.service)
        
        try! keychain.set(data.base64EncodedString(), key: KeychainUtils.nfcModelkey)
    }
    
    static func getNfcModelData() -> String? {
        let keychain = Keychain(service: KeychainUtils.service)
        
        return try! keychain.get(KeychainUtils.nfcModelkey)
    }
    
    static func eraceData() {
        let keychain = Keychain(service: KeychainUtils.service)
        
        try! keychain.remove(KeychainUtils.nfcModelkey)
    }
}
