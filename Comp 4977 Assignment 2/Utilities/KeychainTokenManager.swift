import Foundation

/// A small utility that provides token-specific convenience wrappers around the low-level
/// `KeychainHelper`.
///
/// This struct centralizes the `service` and `account` identifiers used for token storage and
/// provides simple APIs to save, retrieve and remove a String token (for example a JWT).
/// The implementation stores the token as UTF-8 `Data`.
///
/// Example
/// ```swift
/// // Save
/// KeychainTokenManager.saveToken("my.jwt.token")
///
/// // Retrieve
/// let token = KeychainTokenManager.getToken()
///
/// // Remove
/// KeychainTokenManager.removeToken()
/// ```
struct KeychainTokenManager {
    /// The Keychain service identifier (configured in `Config`).
    private static let service = Config.keychainService

    /// The Keychain account identifier (configured in `Config`).
    private static let account = Config.keychainAccount

    /// Save (or remove) the token.
    ///
    /// - Parameter token: The token string to save. If `nil` is provided the stored token will be
    ///   removed instead.
    static func saveToken(_ token: String?) {
        guard let token = token else {
            removeToken()
            return
        }
        let data = Data(token.utf8)
        KeychainHelper.standard.save(data, service: service, account: account)
    }

    /// Retrieve the stored token string, if present.
    ///
    /// - Returns: The token as `String` when present, otherwise `nil`.
    static func getToken() -> String? {
        guard let data = KeychainHelper.standard.read(service: service, account: account) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    /// Remove the stored token from the Keychain.
    static func removeToken() {
        KeychainHelper.standard.delete(service: service, account: account)
    }
}
