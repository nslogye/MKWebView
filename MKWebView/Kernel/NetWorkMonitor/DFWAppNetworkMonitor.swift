//
//  DFWAppNetworkMonitor.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/24.
//

import UIKit
import Foundation
import CoreTelephony
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork


@objc enum DFWNetworkConnection: Int {
    case Wifi       = 0         //使用wifi
    case WWAN       = 1         //2/3/4/5G/../
    case Not        = 2         //当前无网络
    case None       = 3         //未授权
}

public extension Notification.Name {
    /// 网络变化通知
    static let dfwNetworkDidChanged = Notification.Name("dfwNetworkDidChanged")
}


final class DFWAppNetworkMonitor: NSObject {
    
    @objc private static let monitor = DFWAppNetworkMonitor.init()
    
    /*@objc*/ lazy var reachability: Reachability = {
        let r = try! Reachability()
        return r
    }()
    
//    private var networkStatus: DFWNetworkConnection =
    
    private override init(){
        super.init()
    }
    
    /// 开始网络监听
    @objc dynamic public class func startNotifier() {
        let monitor = Self.monitor
        monitor.sNotifier()
    }
    
    /// 停止网络监听
    @objc dynamic public class func stopNotifier() {
        let monitor = Self.monitor
        monitor.spNotifier()
    }
    
    /// 判断当前是否联网
    /// - Returns:  true | false
    @objc dynamic public class func isConnection() -> Bool {
        let monitor = Self.monitor
        let connection = monitor.reachability.connection
        if(connection == .wifi || connection == .cellular) {
            return true
        }
        return false
    }
    
    /// 是否wifi
    /// - Returns: true | false
    @objc dynamic public class func isWifi() ->Bool {
        let monitor = Self.monitor
        let connection = monitor.reachability.connection
        return (connection == .wifi)
    }
    
    /// 是否手机流量
    /// - Returns: true | false
    @objc dynamic public class func isWWAN() -> Bool {
        let monitor = Self.monitor
        let connection = monitor.reachability.connection
        return (connection == .cellular)

    }
    
    /// 获取设备流量类型
    /// - Returns: 2/3/4/5g
    @objc dynamic public class func getWWANName() -> String {
        let info = CTTelephonyNetworkInfo.init()
        let currentStatus = info.currentRadioAccessTechnology
        let unknown = ""
        if(currentStatus == nil){
            return unknown
        }
        let cs = currentStatus!
        let type2G = [CTRadioAccessTechnologyEdge,
                       CTRadioAccessTechnologyGPRS,
                       CTRadioAccessTechnologyCDMA1x]
        let type3G = [CTRadioAccessTechnologyHSDPA,
                       CTRadioAccessTechnologyWCDMA,
                       CTRadioAccessTechnologyHSUPA,
                       CTRadioAccessTechnologyCDMAEVDORev0,
                       CTRadioAccessTechnologyCDMAEVDORevA,
                       CTRadioAccessTechnologyCDMAEVDORevB,
                       CTRadioAccessTechnologyeHRPD]
        let type4G = [CTRadioAccessTechnologyLTE]
        if #available(iOS 14.1, *) {
            let type5G = [CTRadioAccessTechnologyNRNSA,CTRadioAccessTechnologyLTE]
            if(type5G.contains(cs)){
                return "5G"
            }
        }
        if(type4G.contains(cs)){
            return "4G"
        }
        if(type3G.contains(cs)){
            return "3G"
        }
        if(type2G.contains(cs)){
            return "2G"
        }
        return unknown
    }
    
    /// 获取设备当前wifi名称
    /// - Returns: String
    @objc dynamic public class func getWifiName() -> String {
        let wifiInterfaces = CNCopySupportedInterfaces()
        if wifiInterfaces == nil {
            return ""
        }
        let interfaceArr = CFBridgingRetain(wifiInterfaces!) as! Array<String>
        if interfaceArr.count > 0 {
            let interfaceName = interfaceArr[0] as CFString
            let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
            if (ussafeInterfaceData != nil) {
                //wifi name
                let infos = ussafeInterfaceData as! Dictionary<String, Any>
                let ssid = infos["SSID"] as? String
                let wifiName = ssid ?? ""
                return wifiName
            }
        }
        return ""
    }
    
    //MARK: Private
    @objc dynamic private func sNotifier() {
        do {
            try self.reachability.startNotifier()
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: Notification.Name.reachabilityChanged, object: self.reachability)
        }catch {
            print("networkmonitor error: \(error)")
        }
    }
    
    @objc dynamic private func reachabilityChanged(note: Notification) {
        let rby = note.object as! Reachability
        var connect: DFWNetworkConnection?
        switch rby.connection {
        case .wifi:
            connect = .Wifi
            break
        case .cellular:
            connect = .WWAN
            break
        case .unavailable:
            connect = .Not
            break
        case .none:
            connect = .None
            break
        }
        if(connect != nil){
            let type = connect!.rawValue
            NotificationCenter.default.post(name: Notification.Name.dfwNetworkDidChanged, object: type)
        }
    }
    
    @objc dynamic private func spNotifier() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
