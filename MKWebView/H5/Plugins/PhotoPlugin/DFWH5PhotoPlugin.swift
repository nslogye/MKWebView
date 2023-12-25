//
//  DFWH5PhotoPlugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit


class DFWH5PhotoPlugin: DFWH5Plugin {

    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .TakePhotoOnly:
            self.takePhotoOnly(message: message)
            break
        case .ChoosePic:
            self.choosePic(message: message)
            break
        case .BrowsePictures:
            self.browsePictures(message: message)
        default: break
        }
    }
    
    //MARK: Private
    @objc dynamic private func takePhotoOnly(message: Dictionary<String, Any>) {
        var data = self.getDataDict()
        data["picUrl"] = "https://img.com.dongfu/images/2020/2531132351.png"
        var respData = self.getRespDataWith(message: message)
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        LoadingHUD.showToastWithStatus(status: "takePhotoOnly方法名点击")
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    /// 选择照片
    @objc dynamic private func choosePic(message: Dictionary<String, Any>) {
        var data = self.getDataDict()
        var picturesUrl = Array<String>()
        picturesUrl.append("https://f12.baidu.com/it/u1=828951239&u2=3953798257&fm=76")
        picturesUrl.append("https://f12.baidu.com/it/u1=824364704&u2=134968610&fm=76")
        data["picturesUrl"] = picturesUrl
        var respData = self.getRespDataWith(message: message)
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        respData["data"] = data
        LoadingHUD.showToastWithStatus(status: "choosePic方法名点击")
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    /// 图片浏览
    @objc dynamic private func browsePictures(message:Dictionary<String, Any>){
        let data = self.getDataDict()
        var respData = self.getRespDataWith(message: message)
        respData["params"] = data
        self.delegate?.commandJsCompletedCallback(respData: message, webView: self.webView)
    }
    
}
