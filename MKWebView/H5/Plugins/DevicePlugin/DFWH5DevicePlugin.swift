//
//  DFWH5DevicePlugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit
import AdSupport

class DFWH5DevicePlugin: DFWH5Plugin {
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .GetDeviceInfo:
            self.getDeviceInfo(message: message)
            break
        case .GetWifiInfo:
            self.getWifiInfo(message: message)
            break
        case .GetMacAddressInfo:
            self.getMacAddressInfo(message: message)
            break
        default: break
        }
    }
    
    //MARK: Private
    @objc dynamic private func getDeviceInfo(message: Dictionary<String, Any>){
        var respData = self.getRespDataWith(message: message)
        //设备id
        let deviceId = DFWOperationToolsFile.getDeviceId()
        var data = self.getDataDict()
        data["versionCode"] = "iOS " + UIDevice.current.systemVersion //iOS_12.2
        data["manufacturer"] = "apple"
        data["model"] = DFWDeviceManager.getDeviceModel()
        data["macAddress"] = DFWDeviceManager.getMacAddress()
        data["iOSId"] = deviceId
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    @objc dynamic private func getWifiInfo(message: Dictionary<String, Any>){
        var respData = self.getRespDataWith(message: message)
        var data = self.getDataDict()
        let wifiName = DFWDeviceManager.getWifiName()
        data["wifiName"] = wifiName
        respData["code"] = DFWWebCommandCallBackCodeType.Success
        respData["data"] = data
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    @objc dynamic private func getMacAddressInfo(message: Dictionary<String, Any>){
        var respData = self.getRespDataWith(message: message)
        var data = self.getDataDict()
        let macAddr = DFWDeviceManager.getMacAddress()
        data["macAddr"] = macAddr
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
}
