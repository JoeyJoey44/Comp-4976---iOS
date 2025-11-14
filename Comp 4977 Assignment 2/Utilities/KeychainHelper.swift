import Foundation
import Security

final class KeychainHelper {
    static let standard = KeychainHelper() // singleton pattern
    private init() {} // prevent creating extra instances

    // Save data into keychain (overwrites existing)
    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, //saving password-like data
            kSecAttrService as String: service, //which app feature/store this belongs to
            kSecAttrAccount as String: account, //what “user / item name” this data belongs to
            kSecValueData as String: data //the actual data (token)
        ]

        // Delete old value if present
        SecItemDelete(query as CFDictionary)
        // Add new value
        SecItemAdd(query as CFDictionary, nil)
    }

    // Read data
    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }

        return result as? Data
    }

    // Delete data
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
