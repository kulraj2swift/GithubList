//
//  AES.swift
//  GithubList
//
//  Created by kulraj singh on 21/04/25.
//

import Foundation
import CommonCrypto

struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data

    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
    
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
    
    
        self.key = keyData
        self.iv  = ivData
    }


    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    func getEncryptedText(plainText: String?) -> String? {
        guard let plainText = plainText else { return nil }
        return encrypt(string: plainText)?.hexEncodedString()
    }
    
    func getPlainText(encryptedText: String?) -> String? {
        let encryptedData = encryptedText?.hexadecimal
        return decrypt(data: encryptedData)
    }

    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
    
        let cryptLength = data.count + key.count
        var cryptData   = Data(count: cryptLength)
    
        var bytesLength = Int(0)
    
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), keyBytes.baseAddress, key.count, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
    
        guard Int32(status) == Int32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
    
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

