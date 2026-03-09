//
//  KeychainManager.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation
import Security

final class KeychainManager {

    static let shared = KeychainManager()
    private init() {}

    // MARK: - Keys
    
    private let accessTokenKey = "ACCESS_TOKEN"
    private let refreshTokenKey = "REFRESH_TOKEN"

    // MARK: - Public Computed Properties
    /// 로그아웃할 때 토큰 삭제 KeychainManager.shared.accessToken = nil
    var accessToken: String? {
        get { read(key: accessTokenKey) }
        set {
            if let value = newValue {
                save(key: accessTokenKey, value: value)
            } else {
                delete(key: accessTokenKey)
            }
        }
    }

    var refreshToken: String? {
        get { read(key: refreshTokenKey) }
        set {
            if let value = newValue {
                save(key: refreshTokenKey, value: value)
            } else {
                delete(key: refreshTokenKey)
            }
        }
    }

    // MARK: - Save
    
    private func save(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            // 기존 값 삭제
            delete(key: key)

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]

            SecItemAdd(query as CFDictionary, nil)
        }
    }

    // MARK: - Read
    
    private func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    // MARK: - Delete
    
    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }

    func clearAll() {
        accessToken = nil
        refreshToken = nil
    }
}
