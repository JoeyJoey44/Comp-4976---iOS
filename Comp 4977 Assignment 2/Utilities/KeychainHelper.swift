import Foundation
import Security

/// A small helper to store, retrieve and delete generic password items in the system Keychain.
///
/// Use the shared singleton instance `KeychainHelper.standard` to access convenience methods.
/// This class intentionally provides a compact API for simple token-like data (for example JWT
/// tokens). It performs a delete-before-add when saving to ensure the new value replaces any
/// existing item with the same `service`/`account` pair.
///
/// - Note: This is a lightweight wrapper. It does not currently surface detailed Keychain
///   errors to callers — it returns `nil` on reads when the item is missing or the lookup
///   fails. If you need fine-grained error handling, adapt the APIs to return `OSStatus`.
final class KeychainHelper {
    /// Shared singleton instance.
    static let standard = KeychainHelper()

    /// Private initializer to enforce singleton usage.
    private init() {}

    /// Save data into the Keychain. If an item with the same `service` and `account` already
    /// exists, it will be removed and the new value added.
    ///
    /// - Parameters:
    ///   - data: The raw data to store (for example `Data` from a UTF-8 token string).
    ///   - service: A string used to group related Keychain items (commonly the bundle ID or a
    ///     feature-specific identifier).
    ///   - account: The account identifier for the item (for example `"jwtToken"` or a user id).
    ///
    /// - Important: This method overwrites existing items by deleting any matching entry before
    ///   adding the new one. It intentionally does not return an error value; add error
    ///   handling if you need to surface SecItem API failures to callers.
    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        // Delete old value if present then add the new one.
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    /// Read data for a given service/account pair.
    ///
    /// - Parameters:
    ///   - service: The service identifier used when the item was saved.
    ///   - account: The account identifier used when the item was saved.
    /// - Returns: The stored `Data` if present, otherwise `nil`.
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

    /// Delete a Keychain item matching the given service and account.
    ///
    /// - Parameters:
    ///   - service: The service identifier used when the item was saved.
    ///   - account: The account identifier used when the item was saved.
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
