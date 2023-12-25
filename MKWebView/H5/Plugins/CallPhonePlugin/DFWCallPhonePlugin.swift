//
//  DFWCallPhonePlugin.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2021/3/9.
//

import UIKit


class DFWCallPhonePlugin: DFWH5Plugin {
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .MakePhoneCall:
            self.makePhoneCall(message: message)
            break
        default: break
        }
    }
    ///调用拨打电话功能
    @objc dynamic private func makePhoneCall(message: Dictionary<String, Any>) {
        guard let params = self.getJsParams(message: message) else {
            return
        }
        let phoneNumber = params["phoneNumber"] as? String
        //拨打电话
        let url:NSURL = NSURL.init(string: "telprompt://"+phoneNumber!)!
        UIApplication.shared.open(url as URL, options: [:]) { (finshed) in
            
        }
        var respData = self.getRespDataWith(message: message)
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
}
