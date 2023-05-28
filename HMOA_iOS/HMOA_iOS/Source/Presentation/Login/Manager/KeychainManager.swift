//
//  KeychainManager.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/05/26.
//

import Foundation


class KeychainManager {
    
    static func create(token: Token) {
        
        guard let data = try? JSONEncoder().encode(token) else {
            fatalError("토큰 직렬화 실패")
        }
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "token",
            kSecValueData: data
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "토큰 저장 실패")
    }
    
    static func read() -> Token? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "token",
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: .utf8)
            
            guard let token = try? JSONDecoder().decode(Token.self, from: retrievedData) else {
                fatalError("토큰 역직렬화 실패")
            }
            
            return token
        } else {
            return nil
        }
    }
    
    static func delete() {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "token"
        ]
        
        let status = SecItemDelete(query)
        assert(status == noErr, "토큰 삭제 실패")
    }
}
