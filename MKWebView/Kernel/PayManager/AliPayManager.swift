//
//  AliPayManager.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2020/12/17.
//

import UIKit

fileprivate let DFWAlipayScheme = "dfflMaxlAlipayScheme"


class AliPayManager: NSObject {
    @objc static let shared = AliPayManager()
    ///登录成功的闭包
    @objc fileprivate var loginSuccessClosure:((_ auth_code:String) -> Void)?
    ///登录失败的闭包
    @objc fileprivate var loginFailClosure:(() -> Void)?
    // 外部用这个方法调起支付支付
    
    ///支付回调
    @objc fileprivate static var payResultCompletion: ((_ resultDic: Dictionary<AnyHashable, Any>?) -> Void)?
    
    @objc dynamic public static func aliPay(request: String,
                              completion: @escaping (_ resultDic: Dictionary<AnyHashable, Any>?) -> Void) {
        self.payResultCompletion = completion
        AlipaySDK.defaultService()?.payOrder(request, fromScheme: DFWAlipayScheme, callback: { (resultDic) in
            self.handlePayResult(resultDic)
        })
    }
    
    @objc dynamic public static func handlePayResult(_ resultDic: Dictionary<AnyHashable, Any>?) {
        self.payResultCompletion?(resultDic)
    }
    
    //外部用这个方法调起支付宝登录
    @objc dynamic func login(_ sender:DFWBaseRootViewController,withInfo:String,loginSuccess: @escaping (_ str:String) -> Void,loginFail:@escaping () -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        AlipaySDK.defaultService().auth_V2(withInfo:withInfo, fromScheme:"这里是URL Types配置的URLSchemes", callback:nil)
    }
    ///授权回调
    @objc dynamic func showAuth_V2Result(result:NSDictionary){
        //        9000    请求处理成功
        //        4000    系统异常
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        var returnMsg:String = ""
        switch  returnCode{
        case "6001":
            returnMsg = "用户中途取消"
            break
        case "6002":
            returnMsg = "网络连接出错"
            break
        case "4000":
            returnMsg = "系统异常"
            break
        case "9000":
            returnMsg = "授权成功"
            break
        default:
            returnMsg = "系统异常"
            break
        }
        LoadingAlert.show(title: "授权结果", message: returnMsg,direction:.TextDirectionCenter, commitButton: "确定", backgorundHide: false) { (index) in
            if returnCode == "9000" {
                let r=result["result"] as! String
                self.loginSuccessClosure?(r)
                
            }else{
                self.loginFailClosure?()
            }
        }
        
    }
    //传入回调参数
    @objc dynamic func showResult(result:NSDictionary){
        //        9000    订单支付成功
        //        8000    正在处理中
        //        4000    订单支付失败
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
//        var returnMsg:String = ""
//        switch  returnCode{
//        case "6001":
//            returnMsg = "用户中途取消"
//            break
//        case "6002":
//            returnMsg = "网络连接出错"
//            break
//        case "8000":
//            returnMsg = "正在处理中"
//            break
//        case "4000":
//            returnMsg = "订单支付失败"
//            break
//        case "9000":
//            returnMsg = "支付成功"
//            break
//        default:
//            returnMsg = "订单支付失败"
//            break
//        }
//        UIAlertController.showAlertYes(sender, title: "支付结果", message: returnMsg, okButtonTitle:"确定", okHandler: { (alert) in
//            if returnCode == "9000" {
//                self.paySuccessClosure?()
//
//            }else{
//                self.payFailClosure?()
//            }
//        })
       
    }
}
