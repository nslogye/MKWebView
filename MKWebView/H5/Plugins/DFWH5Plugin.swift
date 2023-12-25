//
//  DFWH5Plugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/1.
//

import UIKit


open class DFWH5Plugin: NSObject {

    @objc weak var webView: DFWWebView?
    
    @objc weak var delegate: DFWWebCommandDelegate?
    
    @objc dynamic open func handlerJsMessage(message: Dictionary<String, Any>){
        
    }
    
    @objc dynamic open func getJsParams(message: Dictionary<String, Any>) -> Dictionary<String, Any>?{
        return message["params"] as? Dictionary<String, Any>
    }
    
    @objc dynamic open func getDataDict() -> Dictionary<String, Any> {
        
        return Dictionary<String, Any>()
    }
    
    @objc dynamic public func getRespDataWith(message: Dictionary<String, Any>) -> Dictionary<String, Any>{
        let callbackTag = message[kDWFWebCallbackTag]
        var respData = self.getDataDict()
        if(callbackTag != nil) {
            respData[kDWFWebCallbackTag] = callbackTag
        }
        return respData
    }
}
