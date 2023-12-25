//
//  DFWDeviceManager.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit
import SystemConfiguration.CaptiveNetwork



class DFWDeviceManager: NSObject {
    
        
    /// 判断是否位模拟器
    ///
    /// - Returns: true 模拟器； false 真机
    @objc dynamic public class func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    
    /// 获取设备机型， 如iPhone 8  iPad 4
    /// - Returns: device model
    @objc dynamic public class func getDeviceModel() -> String {
        if self.isSimulator() {
            //如果是模拟器
            return "iOS Simulator"
        }
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        //ipod
        case "iPod1,1":
            return "iPod Touch 1G"
        case "iPod2,1":
            return "iPod Touch 2G"
        case "iPod3,1":
            return "iPod Touch 3G"
        case "iPod4,1":
            return "iPod Touch 4G"
        case "iPod5,1":
            return "iPod Touch 5G"
        case "iPod7,1":
            return "iPod Touch 6G"
            
        case "iPhone1,1":
            return "iPhone 2G"
        case "iPhone1,2":
            return "iPhone 3G"
        case "iPhone2,1":
            return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"
            
        case "iPhone5,1":
            return "iPhone 5"
        case "iPhone5,2":
            return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":
            return "iPhone 5c (GSM)"
        case "iPhone5,4":
            return "iPhone 5c (GSM+CDMA)"
            
        case "iPhone6,1":
            return "iPhone 5s (GSM)"
        case "iPhone6,2":
            return "iPhone 5s (GSM+CDMA)"
            
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
            
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone9,1":
            return "iPhone 7"
        case "iPhone9,2":
            return "iPhone 7 Plus"
        case "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,4":
            return "iPhone 7 Plus"
            
        case "iPhone10,1":
            return "iPhone 8"
        case "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2":
            return "iPhone 8 Plus"
        case "iPhone10,5":
            return "iPhone 8 Plus"
            
        case "iPhone10,3":
            return "iPhone X"
        case "iPhone10,6":
            return "iPhone X"
            
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"
 
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
    
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12  Pro"
        case "iPhone13,4":
            return "iPhone 12  Pro Max"
            
        case "iPhone14,1":
            return "iPhone 13"
        case "iPhone14,2":
            return "iPhone 13 Pro"
        case "iPhone14,3":
            return "iPhone 13 Pro Max"
            
        case "iPad1,1":
            return "iPod Touch 1G"
        case "iPad1,2":
            return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPod Touch 2G"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini 1G"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro 12.9"
            
        case "AppleTV2,1":
            return "Apple TV 2"
        case "AppleTV3,1", "AppleTV3,2":
            return "Apple TV 3"
        case "AppleTV5,3":
            return "Apple TV 4"
        default:
            return "Apple" + " " + identifier
        }
    }
    
    /// 获取wifi的ip地址
    /// - Returns: ip地址
    @objc dynamic public class func getWifiIp() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
         
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
         
        freeifaddrs(ifaddr)
        return address
    }
    
    /// 获取运营商ip
    /// - Returns: ip地址
    @objc dynamic public class func getNewWorkIp() -> String? {
        var addresses = [String]()
            var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while (ptr != nil) {
                    let flags = Int32(ptr!.pointee.ifa_flags)
                    var addr = ptr!.pointee.ifa_addr.pointee
                    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                        if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String(validatingUTF8:hostname) {
                                    addresses.append(address)
                                }
                            }
                        }
                    }
                    ptr = ptr!.pointee.ifa_next
                }
                freeifaddrs(ifaddr)
            }
            return addresses.first
    }

    /// 获取当前wifi名称
    ///
    /// - Returns: wifi名称
    @objc dynamic public class func getWifiName() -> String {
        if(self.isSimulator()){
            return "wifi must not used in simulator"
        }
        var wifiName: String = ""
        let infos = self.getNetworkInfo()
        let ssid = infos["SSID"] as? String
        wifiName = ((ssid != nil) ? ssid! : "")
        return wifiName
    }
    
    
    /// 获取当前mac地址
    ///
    /// - Returns: mac地址
    @objc dynamic public class func getMacAddress() -> String {
        if(self.isSimulator()){
            return "macAddress must not used in simulator"
        }
        var macAddress: String = ""
        let infos = self.getNetworkInfo()
        let bSSID = infos["BSSID"] as? String
        macAddress = ((bSSID != nil) ? bSSID! : "")
        return macAddress
    }
    
    
    /// 获取设备的品牌
    ///
    /// - Returns: 设备品牌
    @objc dynamic public class func getDeviceBrand() ->String {
        if(self.isSimulator()){
            return "simulator"
        }
        var deviceBrand = ""
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            deviceBrand = "iPad"
        } else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            deviceBrand = "iPhone"
        } else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.tv) {
            deviceBrand = "tvOS"
        } else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.carPlay) {
            deviceBrand = "carPlay"
        }else{
            deviceBrand = "unkown"
        }
        return deviceBrand
    }
    
    //MARK: Private
    @objc dynamic private class func getNetworkInfo() -> Dictionary<String, Any>{
        let infos = Dictionary<String, Any>()
        let wifiInterfaces = CNCopySupportedInterfaces()
        if wifiInterfaces == nil {
            return infos
        }
        let interfaceArr = CFBridgingRetain(wifiInterfaces!) as! Array<String>
        if interfaceArr.count > 0 {
            let interfaceName = interfaceArr[0] as CFString
            let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
            if (ussafeInterfaceData != nil) {
                let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                return interfaceData
            }
        }
        return infos
    }
}
