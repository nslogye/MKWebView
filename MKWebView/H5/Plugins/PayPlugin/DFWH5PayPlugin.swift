//
//  DFWH5PayPlugin.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2020/12/18.
//

import UIKit


class DFWH5PayPlugin: DFWH5Plugin {
    
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .Alipay:
            self.alipay(message: message)
            break
        case .WXpay:
            self.wxpay(message: message)
             break
        case .IsWXInstalled:
            self.isWXAppInstalled(message: message)
            break
        default: break
        }
    }
    
    
    @objc dynamic private func alipay(message: Dictionary<String, Any>) {
        guard let params = self.getJsParams(message: message) else {
            return
        }
        let orderInfo = (params["orderInfo"] as? String) ?? ""
        AliPayManager.aliPay(request: orderInfo) { (result) in
            
            if let webView = self.webView {
                var respData = self.getRespDataWith(message: message)
                let returnCode = (result?["resultStatus"] as? String) ?? ""
                if returnCode == "9000" { //成功
                    respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
                }else {
                    respData["code"] = DFWWebCommandCallBackCodeType.UserToPayCancel.rawValue
                }
                
                self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
            }
        }
    }
    
    @objc dynamic private func wxpay(message: Dictionary<String, Any>) {
        guard let params = self.getJsParams(message: message) else {
            return
        }
        //调起微信支付
        WXApiManager.wxPay(request: params) { (code, msg) in
            var respData = self.getRespDataWith(message: message)
            if WXErrCode.init(rawValue: Int32(code))  == WXSuccess { //支付成功
                respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
            }else {
                respData["code"] = DFWWebCommandCallBackCodeType.UserToPayCancel.rawValue
            }
            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
        }
        
    }
    
    
    @objc dynamic private func isWXAppInstalled(message: Dictionary<String, Any>) {
        var respData = self.getRespDataWith(message: message)
        if WXApi.isWXAppInstalled() {
            respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        }else {
            respData["code"] = DFWWebCommandCallBackCodeType.UserToPayCancel.rawValue
        }
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
}
