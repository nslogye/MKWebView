//
//  DFWUserDefault.swift
//  DFIOSComponents
//
//  Created by sunshine on 2023/7/31.
//

import UIKit
/*
 为什么会有db
    - 阿里云日志系统在iOS 17系统以上删除写入UserDefaults中的用户信息
 */
/// 是否已经迁移过UserDefault
public let kIsMigrationsDefault = "IsMigrationsDefault"
open class DFWUserDefault: NSObject {     
    /// 获取UserDefault
    @objc public dynamic static func getUserDefault(key: String) -> String? {
        let value = UserDefaults.standard.object(forKey: key) as? String
        return value

    }
    

    /// 赋值
    @objc public dynamic static func setUserDefault(key: String, value: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        
      
    }

    
    /// 重置
    @objc public dynamic static func removeObject(key: String) {
        UserDefaults.standard.removeObject(forKey: key)

    }
}
