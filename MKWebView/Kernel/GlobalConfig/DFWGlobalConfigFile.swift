//
//  DFWGlobalConfigFile.swift
//  DongFuWang
//
//  Created by lianggq on 2020/10/24.
//

import Foundation
import UIKit

//app
let ApplicationWidth = UIScreen.main.bounds.size.width     //width

let ApplicationHeight = UIScreen.main.bounds.size.height    //height

let ApplicationInfoDict = Bundle.main.infoDictionary!    //app应用数据

let AppStatusBarHeight = UIApplication.shared.statusBarFrame.height //状态栏高度

let AppContentBarHeight = 44.0  //导航内容高度

let AppNavBarHeight = (AppStatusBarHeight + AppContentBarHeight)

let AppScale = UIScreen.main.scale

let AppTabBarHeight = (AppSafeAreaBottom + 49.0)


///获得当前窗口
let AppDelegate = UIApplication.shared.delegate as? MKAppDelegate

let AppSafeAreaTop = AppDelegate!.window!.safeAreaInsets.top

let AppSafeAreaBottom = AppDelegate!.window!.safeAreaInsets.bottom

let AppViewHeight = ApplicationHeight - AppSafeAreaTop - AppSafeAreaBottom


/// 状态栏高度
public func df_StatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = df_IsBangScreen() ? 44 : 20
    if #available(iOS 11.0, *) {
        if let top: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            return top
        }
    } else {
        let height: CGFloat = UIApplication.shared.statusBarFrame.size.height
        if height >= statusBarHeight {
            statusBarHeight = height
        }
    }
    return statusBarHeight
}

/// 导航栏高度
public func df_NaviBarHeight() -> CGFloat {
    return 44.0
}
 

/// 导航栏MaxY
public func df_NaviBarMaxY() -> CGFloat {
    return df_StatusBarHeight() + df_NaviBarHeight()
}
 
 
/// 底部安全距离
public func df_SafeBottomArea() -> CGFloat {
    var safeBottom: CGFloat = 0
    if #available(iOS 11, *) {
        let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets
        safeBottom = safeArea?.bottom ?? 0
    }
    return safeBottom
}

/// TabBar高度(底部安全距离+TabBar内容高度)
public func df_TabBarHeight() -> CGFloat {
    return df_SafeBottomArea() + AppContentBarHeight
}


/// 是否是刘海屏
func df_IsBangScreen() -> Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
    }
    return false
}


//沙盒目录
let AppDocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String

let AppHomePath = NSHomeDirectory() as String      //沙盒跟目录

let AppTempPath = NSTemporaryDirectory()           //temp目录

let AppCachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String

 

/**
 *  获取系统版本
 */
let App_System_Version = UIDevice.current.systemVersion
/**
 *  获取当前语言
 */
let AppCurrentLanguage = NSLocale.preferredLanguages[0]



/// Debug环境打印
/// - Parameters:
///   - messsage: 打印内容
///   - file: 文件名
///   - funcName: 函数名
///   - lineNum: 行数
func DFWLog<T>(messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):(\(lineNum))-\(messsage)")
    #endif
}
