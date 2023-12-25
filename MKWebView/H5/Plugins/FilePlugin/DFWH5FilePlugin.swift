//
//  DFWH5FilePlugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit
import SwiftyJSON

class DFWH5FilePlugin: DFWH5Plugin {
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .ClearCache:
            self.clearCache(message: message)
            break
        case .appGetFloatWindow:
            // H5获取app悬浮窗数据
            getFloatWindow(message: message)
            break
        case .appSetFloatWindow:
            // h5向app添加数据
            setFloatWindow(message: message)
            break
        default: break
        }
    }
    
    //MARK:
    @objc dynamic private func clearCache(message: Dictionary<String, Any>) {
        var respData = self.getRespDataWith(message: message)
        var data = self.getDataDict()
        data["msg"] = "缓存清理完成"
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    // h5向app添加数据
    @objc dynamic func setFloatWindow(message: Dictionary<String, Any>) {
        let json = JSON(message).dictionaryValue
        let floatWindow: String = json["params"]?["floatWindow"].stringValue ?? ""
        DFWH5FloatViewData.share.setData(floatWindow)
        var respData = self.getRespDataWith(message: message)
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    // H5获取app悬浮窗数据
    @objc dynamic func getFloatWindow(message: Dictionary<String, Any>) {
        var respData = getRespDataWith(message: message)
        let list = DFWH5FloatViewData.share.getData()
        var data: [Any] = Array()
        for item in list {
            data.append(["floatWindow": item])
        }
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    

}
