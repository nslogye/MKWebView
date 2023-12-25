//
//  DFWH5LocationPlugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit


class DFWH5LocationPlugin: DFWH5Plugin {
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .GetGpsLoc:
            self.getGpsLoc(message: message)
            break
            
        default: break
        }
    }
    
    //MARK:
    @objc dynamic private func getGpsLoc(message: Dictionary<String, Any>) {
        var respData = self.getRespDataWith(message: message)
        var data = self.getDataDict()
//        DFWLocationService.singleton().startOnceLocation { status, latitudeString, longitudeString in
//            data["latitude"] = latitudeString
//            data["longitude"] = longitudeString
//            //经纬度为空
//            if DFWLocationService.singleton().currentLatitude == "" {
//                respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
//            }else{
//                respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
//            }
//            respData["data"] = data
//            print("单次定位回调了---",latitudeString,longitudeString)
//            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
//        }
        
    }
}
