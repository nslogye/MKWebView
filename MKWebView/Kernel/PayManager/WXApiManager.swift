//
//  WXApiManager.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2020/12/17.
//

import UIKit
/// 微信appid
let WeChatAPP_ID = "wx246b4afeec1f8d9c"
/// 微信serets
let WeChatAPP_SECRET = "9d29257170b296231d7fa18c9464489c"
/// 微信universal link url
let WeChatAPP_UniversalLink = "https://app.dongfangfuli.com/maxapp/"
class WXApiManager: NSObject, WXApiDelegate {
    
    @objc static let shared = WXApiManager()
    
    ///支付回调
    @objc private static var payResultCompletion: ((_ code: Int, _ msg: String) -> Void)?
    
    @objc dynamic public static func wxPay(request: Dictionary<String, Any>,
                             completion: @escaping (_ code: Int, _ msg: String) -> Void) {
        self.payResultCompletion = completion
        //支付
        if let appid = request["appid"] as? String {
            WXApi.registerApp(appid, universalLink: WeChatAPP_UniversalLink)
        }
        let wxReq = PayReq.init()
        wxReq.partnerId = (request["partnerid"] as? String) ?? ""
        wxReq.prepayId  = (request["prepayid"] as? String) ?? ""
        wxReq.nonceStr  = (request["noncestr"] as? String) ?? ""
        let timeStamp = request["timestamp"]
        if let t = timeStamp as? UInt32 {
            wxReq.timeStamp = t
        }else if let t = timeStamp as? String {
            wxReq.timeStamp =  UInt32(t) ?? 0
        }
        wxReq.package   = (request["package"] as? String) ?? ""
        wxReq.sign      = (request["sign"] as? String) ?? ""
        WXApi.send(wxReq)
    }
        
    
    //MARK: WXApiDelegate
    @objc dynamic func onReq(_ req: BaseReq) {
        
    }
    
    @objc dynamic func onResp(_ resp: BaseResp) {
        if resp.isKind(of: PayResp.self) { //支付回调
            let payResp = resp as! PayResp
            let code = payResp.errCode
            Self.payResultCompletion?(Int(code), payResp.errStr )
            
        }
        
    }
}
