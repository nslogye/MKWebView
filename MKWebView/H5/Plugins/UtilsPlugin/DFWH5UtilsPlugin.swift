//
//  DFWH5UtilsPlugin.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit
import Foundation


class DFWH5UtilsPlugin: DFWH5Plugin {
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .OpenNewWeb:
            self.openNewWeb(message: message)
            break
        case .Finish:
            self.finishPage()
            break
        case .Goback:
            self.goBack()
            break
        case .SetPageTitle:
            self.setPageTitle(message: message)
            break
        case .OpenThirdPkg:
            self.openThirdPkg(message: message)
            break
        case .ShowPage:
            self.showPage(message: message)
            break
        case .AppRelogin:
            self.relogin()
            break
        default: break
        }
    }
    
    //MARK: Private
    @objc dynamic private func openNewWeb(message: Dictionary<String, Any>){
        guard let params = self.getJsParams(message: message) else {
            return
        }
        guard (params["url"] as? String) != nil else {
            return
        }
        let pageDatas: [String: Any] = ["type": DFWOpenURLType.Web.rawValue, "params": params]
        DFWBaseOpenURL.handleOpenInPageDatas(pageDatas)
    }
    
    @objc dynamic private func showPage(message: Dictionary<String, Any>){
        guard let params = self.getJsParams(message: message) else {
            return
        }
        let name = (params["pageName"] as? String) ?? ""
        var respData = self.getRespDataWith(message: message)
        if DFWBaseOpenURL.pageMappings.keys.contains(name){
            let pageDatas: [String: Any] = ["type": DFWOpenURLType.App.rawValue, "params": params]
            DFWBaseOpenURL.handleOpenInPageDatas(pageDatas)
            respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        }else {
            respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
            respData["msg"] = "pageName参数为空或非法"
        }
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    //
    @objc dynamic private func finishPage(){
        self.pageClose()
    }
    
    @objc dynamic private func goBack() {
        if let webVc = self.webView?.containerVc as? DFWWebViewController {
            webVc.goBack()
        }
    }
    
    @objc dynamic private func setPageTitle(message: Dictionary<String, Any>){
        guard let params = self.getJsParams(message: message) else {
            return
        }
        var title = (params["title"] as? String)
        title = (title != nil) ? title : ""
        self.webView?.containerVc?.setItemTitle(itemTitle: title!)
    }
    
    @objc dynamic private func openThirdPkg(message: Dictionary<String, Any>){
        var respData = self.getRespDataWith(message: message)
        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
        LoadingHUD.showToastWithStatus(status: "openThirdPkg方法名点击")
        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    @objc dynamic private func relogin() {

    }
    
    //
    @objc dynamic private func pageClose() {
        if let nav = self.webView?.containerVc?.navigationController,
           nav.viewControllers.count > 0 {
            nav.popViewController(animated: true)
        } else {
            if let vc = self.webView?.containerVc {
                vc.dismiss(animated: true, completion: {})
            }
        }
    }
}
