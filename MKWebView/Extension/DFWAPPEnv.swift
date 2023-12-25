//
//  DFWAPPEnv.swift
//  DFMaxStore
//
//  Created by qianduan2731 on 2023/7/20.
//

struct MobileProvision: Decodable {
    var name: String
    var appIDName: String
    var platform: [String]
    var isXcodeManaged: Bool? = false
    var creationDate: Date
    var expirationDate: Date
    var entitlements: Entitlements
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case appIDName = "AppIDName"
        case platform = "Platform"
        case isXcodeManaged = "IsXcodeManaged"
        case creationDate = "CreationDate"
        case expirationDate = "ExpirationDate"
        case entitlements = "Entitlements"
    }
    
    // Sublevel: decode entitlements informations
    struct Entitlements: Decodable {
        let keychainAccessGroups: [String]
        let getTaskAllow: Bool
        let apsEnvironment: Environment
        
        private enum CodingKeys: String, CodingKey {
            case keychainAccessGroups = "keychain-access-groups"
            case getTaskAllow = "get-task-allow"
            case apsEnvironment = "aps-environment"
        }
        // Occasionally there will be a disable
        enum Environment: String, Decodable {
            case development, production, disabled
        }
    }
}

class AppEnv {
    
    enum AppCertEnv {
        case devolopment
        case adhoc
        case testflight
        case appstore
    }
    
    var isAppStoreReceiptSandbox: Bool {
        return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }
    
    var embeddedMobileProvisionFile: URL? {
        return Bundle.main.url(forResource: "embedded", withExtension: "mobileprovision")
    }
    
    var appCerEnv: AppCertEnv!
    
    init() {
          // init or other time
        assemblyEnv()
    }
    
    func assemblyEnv() {
        if let provision = parseMobileProvision() {
            switch provision.entitlements.apsEnvironment {
            case .development, .disabled:
                appCerEnv = .devolopment
            case .production:
                appCerEnv = .adhoc
            }
        } else {
            if isAppStoreReceiptSandbox {
                appCerEnv = .testflight
            } else {
                appCerEnv = .appstore
            }
        }
    }
    
    func parseMobileProvision() -> MobileProvision? {
        guard let file = embeddedMobileProvisionFile,
              let string = try? String.init(contentsOf: file, encoding: .isoLatin1) else {
            return nil
        }
        
        // Extract the relevant part of the data string from the start of the opening plist tag to the ending one.
        let scanner = Scanner.init(string: string)
        guard scanner.scanUpTo("<plist", into: nil) != false  else {
            return nil
        }
        var extractedPlist: NSString?
        guard scanner.scanUpTo("</plist>", into: &extractedPlist) != false else {
            return nil
        }
        
        guard let plist = extractedPlist?.appending("</plist>").data(using: .isoLatin1) else { return nil}
        
        let decoder = PropertyListDecoder()
        do {
            let provision = try decoder.decode(MobileProvision.self, from: plist)
            return provision
        } catch let error {
            // TODO: log / handle error
            print(error.localizedDescription)
            return nil
        }
    }
}

