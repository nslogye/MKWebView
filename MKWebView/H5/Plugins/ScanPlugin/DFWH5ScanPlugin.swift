//
//  DFWH5ScanPlugin.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2022/1/17.
//

import UIKit
///添加扫码功能--2.0.0版本以上

class DFWH5ScanPlugin: DFWH5Plugin {
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .OpenScan:
            self.openScan(message: message)
            break
        default: break
        }
    }
    //MARK:
    @objc dynamic private func openScan(message: Dictionary<String, Any>) {
        var respData = self.getRespDataWith(message: message)
        var data = self.getDataDict()
        let vc = DFWQRScanViewController.init()
        vc.getResultUrl { resultUrl in
            vc.dismiss(animated: true) {
                //经纬度为空
                if resultUrl == "" {
                    respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
                    data["resultUrl"] = ""
                }else{
                    respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
                    data["resultUrl"] = resultUrl
                }
                respData["data"] = data
                self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
            }
        }
//        DFWManager.presentViewController(viewController: vc)
        let nvc = DFWBaseRootNavigatController.init(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        nvc.modalPresentationStyle = .fullScreen
        DFWManager.findCurrentViewController()?.present(nvc, animated: true)
        
    }
}
