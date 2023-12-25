//
//  DFWOperationToolsFile.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/12/1.
//

import UIKit
let service_keychain = "com.dongffl.maxstore"
let deviceID_keychain = "uuid"
class DFWOperationToolsFile: NSObject {
    
    /// 获取App当前版本号
    /// - Returns: 版本号
    @objc dynamic public class func getNowVersion() -> String {
        let version = ApplicationInfoDict["CFBundleShortVersionString"] ?? ""
        return version as! String
    }
    
    /// 获取设备唯一id
    /// - Returns: 设备id
    @objc dynamic public class func getDeviceId() -> String {
        var currentDeviceUUIDStr = SAMKeychain.password(forService: service_keychain, account: deviceID_keychain)
        if currentDeviceUUIDStr == nil ||  currentDeviceUUIDStr == ""{
            let currentDeviceUUID = UIDevice.current.identifierForVendor
            currentDeviceUUIDStr = currentDeviceUUID?.uuidString
            SAMKeychain.setPassword(currentDeviceUUIDStr!, forService: service_keychain, account: deviceID_keychain)
        }
        return currentDeviceUUIDStr!
    }
    
    
    
    /// 字典转json
    /// - Parameter dict: 字典
    /// - Returns: description
    @objc dynamic public class func convertDictionaryToJSONString(dict: NSDictionary?)->String {
        if let swfitDict = dict as? Dictionary<String, Any>,
            let jsonStr = swfitDict.convertToString() {
            return jsonStr
        }
        return ""
    }
    
    /// json转字典
    /// - Parameter text: json字符串
    /// - Returns: description
    @objc dynamic public class func convertJSONStringToDictionary(text: String) -> [String: Any]? {
        let dict = text.convertToDictionary()
        return dict
    }

}
