//
//  DFWH5AppPlugin.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2020/12/4.
//

import UIKit


class DFWH5AppPlugin: DFWH5Plugin {
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .GetAppInfo:
            self.getAppInfo(message: message)
            break
        case .BackToHome:
            self.backToHome()
            break
        case .BackToStorehome:
            self.backToStorehome()
            break
        case .GetAuthorizedStatus:
            self.getAuthorizedStatus(message: message)
            break
        case .GoSystemSetting:
            self.goSystemSetting()
            break
        default: break
        }
    }
    
    @objc dynamic private func getAppInfo(message: Dictionary<String, Any>) {
        var respData = self.getRespDataWith(message: message)
        var data = self.getDataDict()
        //版本号 如1.0.0
        data["appVersionName"] = DFWOperationToolsFile.getNowVersion()
        //适配android加个code
        data["appVersionCode"] = DFWOperationToolsFile.getNowVersion()
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    @objc dynamic private func backToHome() {
        DFWManager.popToRootIndexForClsName(clsName: "DFWMainViewController", animated: true)
        self.webView?.containerVc?.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc dynamic private func backToStorehome() {

        DFWManager.popToRootViewController(index: 0, animated: false)
//        self.webView?.containerVc?.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc dynamic private func getAuthorizedStatus(message: Dictionary<String, Any>) {
        let params = self.getJsParams(message: message)
        var respData = self.getRespDataWith(message: message)
        let type = params?["type"] as? String
        if type == nil {
            respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
            respData["msg"] = "type不能为空"
            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
            return
        }
        DFWAuthorizeManager.requestAuthorizedFor(type!) { (authorized, requested) in
            if authorized {
                respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
            }else {
                respData["code"] = DFWWebCommandCallBackCodeType.AuthorizedFailure.rawValue
            }
            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
        }

    }
    
    @objc dynamic private func goSystemSetting() {
        DFWAuthorizeManager.actionToOpenSettings()
    }
    
}
