import Foundation

struct KeychainTokenManager {
    private static let service = Config.keychainService
    private static let account = Config.keychainAccount

    static func saveToken(_ token: String?) {
        guard let token = token else {
            removeToken()
            return
        }
        let data = Data(token.utf8)
        KeychainHelper.standard.save(data, service: service, account: account)
    }

    static func getToken() -> String? {
        guard let data = KeychainHelper.standard.read(service: service, account: account) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    static func removeToken() {
        KeychainHelper.standard.delete(service: service, account: account)
    }
}
