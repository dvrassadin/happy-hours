//
//  KeyChainService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import OSLog

// MARK: - KeyChainService class

final class KeyChainService: KeyChainServiceProtocol {
    
    // MARK: Properties
    
    private let service = "HappyHours" as CFString
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: KeyChainService.self)
    )
    
    // MARK: Updating tokens
    
    private func update(token: Data, identifier: CFString) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: identifier
        ]
        
        let attributes: [CFString: Any] = [kSecValueData: token]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status == errSecSuccess else {
            logger.error("\(status)")
            return false
        }
        
        return true
    }
    
    // MARK: Removing tokens
    
    func deleteAllTokens() {
        JWTType.allCases.forEach { token in
            deleteToken(type: token)
        }
    }
    
    private func deleteToken(type: JWTType) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.identifier
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            logger.error("\(type.identifier) was not deleted.")
            return
        }
        
        logger.info("\(type.identifier) was deleted.")
    }
    
    // MARK: Saving tokens
    
    func save(token: String, type: JWTType) {
        guard let token = token.data(using: .utf8)
        else {
            logger.error("Could not encode \(type.identifier) to data.")
            return
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.identifier,
            kSecValueData: token
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            if update(token: token, identifier: type.identifier) {
                logger.info("\(type.identifier) was updated.")
            }
            return
        }
        
        guard status == errSecSuccess else {
            logger.error("Unexpected error while saving \(type.identifier).")
            return
        }

        logger.info("\(type.identifier) saved in KeyChain.")
    }
    
    // MARK: Getting tokens
    
    func getToken(_ type: JWTType) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue as Any,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            logger.info("\(type.identifier) weren't found.")
            return nil
        }
        
        guard status == errSecSuccess else {
            logger.error("Unexpected error status \(status) while getting \(type.identifier).")
            return nil
        }

        guard let tokenData = item as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            logger.error("Unexpected token data while getting \(type.identifier).")
            return nil
        }
        
        logger.info("\(type.identifier) was received from Key Chain.")
        
        return token
    }
    
    // MARK: Saving credentials
    
    func saveCredentials(email: String, password: String) {
        guard let password = password.data(using: .utf8) else {
            logger.error("Could not encode password data.")
            return
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email,
            kSecValueData: password
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            logger.info("Credentials already exist in KeyChain.")
            return
        }
        
        guard status == errSecSuccess else {
            logger.error("\(status)")
            return
        }
        
        logger.info("Credentials saved in KeyChain.")
    }
    
    // MARK: Getting credentials
    
    func getCredentials() -> (email: String, password: String)? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            logger.info("Credentials weren't found.")
            return nil
        }
        guard status == errSecSuccess else {
            logger.error("\(status)")
            return nil
        }
        
        guard let existingItem = item as? [CFString : Any],
            let passwordData = existingItem[kSecValueData] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let email = existingItem[kSecAttrAccount] as? String
        else {
            logger.error("Unexpected error while getting credentials.")
            return nil
        }

        return (email: email, password: password)
    }
    
}
