//
//  FWH5SharePlugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit


class DFWH5SharePlugin: DFWH5Plugin {
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .Share:
            self.share(message: message)
            break
        
        default: break
        }
    }
    
    //MARK:
    @objc dynamic private func share(message: Dictionary<String, Any>) {
//        var respData = self.getRespDataWith(message: message)
//        let params = self.getJsParams(message: message)
//        let shareObj = DFWShareItemObject(dictionary: params)
//        var platforms: [String]? = nil
//        if let p = params?["platforms"] as? [String] {
//            platforms = p
//        }
//        DFWShareManager.share(shareObj, platformKeys: platforms) { (error) in
//            if error == nil {
//                respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
//            }else {
//                respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
//            }
//            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
//        }
    }
}
