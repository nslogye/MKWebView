//
//  DFWWebCommand.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/3.
//

import UIKit


let kDWFWebCallbackTag      = "callbackTag"

let kDFWWebMethodName       = "methodName"


/// - js传的方法名
enum DFWWebCommandMethodType: String {
    case Unkown             = ""                            //
    case TakePhotoOnly      = "takePhotoOnly"               //只调用native拍照
    case ChoosePic          = "choosePic"                   //选择并上传图片
    case OpenNewWeb         = "openNewWeb"                  //打开新的web页面Page
    case ShowPage           = "showPage"                    //打开新的web页面Page
    case Finish             = "finish"                      //关闭当前页面
    case SetPageTitle       = "setPageTitle"                //设置页面title
    case OpenThirdPkg       = "openThirdPkg"                //打开第三app
    case Goback             = "goback"                      //h5回退
    case GetDeviceInfo      = "getDeviceInfo"               //获取设备信息
    case GetWifiInfo        = "getWifiInfo"                 //获取wifi
    case GetMacAddressInfo  = "getMacAddressInfo"           //获取mac地址
    case Share              = "share"                       //统一分享
    case GetGpsLoc          = "getGpsLoc"                   //获取定位经纬度
    case ClearCache         = "clearCache"                  //清理缓存
    case BrowsePictures     = "browsePictures"              //浏览照片
    case GetAppInfo         = "getAppInfo"                  //获取app信息
    case BackToHome         = "backToHome"                  //返回首页
    case BackToStorehome    = "backToStorehome"             //返回商城首页首页
    case GetCityInfo        = "getCityInfo"                 //获取当前城市数据
    case SwitchCityInfo     = "switchCityInfo"              //修改当前城市
    case Alipay             = "alipay"                      //支付宝支付
    case WXpay              = "wxpay"                       //微信支付
    case IsWXInstalled      = "isWXInstalled"               //是否安装微信
    case AppRelogin         = "relogin"                     //重新登录
    case GetAuthorizedStatus = "getAuthorizedStatus"        //获取授权状态
    case GoSystemSetting    = "goSystemSetting"             //跳转系统设置
    case CallApplets        = "callApplets"                 //跳转小程序
    case MakePhoneCall      = "makePhoneCall"               //拨打电话
    case OpenScan           = "openAppScan"                 //打开扫码页
    case appGetFloatWindow  = "getFloatWindow"           // 获取app内H5悬浮窗数据
    case appSetFloatWindow  = "setFloatWindow"           // 设置app内H5悬浮窗数据

}


/// - 回调的状态码
enum DFWWebCommandCallBackCodeType: String {
    case Success                    = "0"                           //成功
    case NotFound                   = "-1"                          //方法未找到
    case Failure                    = "101"                         //必填数据为空
    case DataFormatFailure          = "201"                         //数据格式错误
    case UserToPayCancel            = "301"                         //用户支付取消
    case AuthorizedFailure          = "501"                         //没有授权和授权失败
}


@objc public protocol DFWWebCommandDelegate: NSObjectProtocol {
    
    /// native回调js处理
    ///
    /// - Parameters:
    ///   - respData:       回调参数
    ///   - webView:        webView载体（webView可能被pop导致nil)
    func commandJsCompletedCallback(respData: Dictionary<String, Any> , webView: DFWWebView?)
    
}




class DFWWebCommand: NSObject, DFWWebCommandDelegate {
    
    @objc private static let sharedCommand: DFWWebCommand = {
        let share = DFWWebCommand.init()
        return share
    }()
    
    private override init() {
        super.init()
    }
    
    //MARK: 接收js方法参数
    @objc dynamic public class func webCommand(didReceive message: Any, webView: DFWWebView) {
        guard message is Dictionary<String, Any> else {
            return
        }
        let body = message as! Dictionary<String, Any>
        print("message.body is \(body)")
        //Pugins
        var plugin: DFWH5Plugin?
        if let methodName = (body[kDFWWebMethodName] as? String),
            let methodType = DFWWebCommandMethodType(rawValue: methodName){
            //如果找到方法名
            switch methodType {
            case .TakePhotoOnly, .ChoosePic, .BrowsePictures:
                plugin = DFWH5PhotoPlugin.init()
                break
            case .OpenNewWeb, .ShowPage, .Finish, .SetPageTitle, .OpenThirdPkg, .Goback, .AppRelogin:
                plugin = DFWH5UtilsPlugin.init()
                break
            case .GetDeviceInfo, .GetWifiInfo, .GetMacAddressInfo:
                plugin = DFWH5DevicePlugin.init()
                break
            case .Share:
                plugin = DFWH5SharePlugin.init()
                break
            case .ClearCache, .appGetFloatWindow, .appSetFloatWindow:
                plugin = DFWH5FilePlugin.init()
                break
            case .GetGpsLoc:
                plugin = DFWH5LocationPlugin.init()
                break
            case .GetAppInfo, .BackToHome, .BackToStorehome, .GetAuthorizedStatus, .GoSystemSetting, .CallApplets:
                plugin = DFWH5AppPlugin.init()
                break
            case .SwitchCityInfo, .GetCityInfo:
                plugin = DFWH5CityPlugin.init()
                break
            case .Alipay, .WXpay, .IsWXInstalled:
                plugin = DFWH5PayPlugin.init()
                break
            case .OpenScan:
                plugin = DFWH5ScanPlugin.init()
                break
            default:
                break
            }
            plugin?.webView = webView
            plugin?.delegate = DFWWebCommand.sharedCommand
            plugin?.handlerJsMessage(message: body)
            
        }else {
            var respData = Dictionary<String, Any>()
            respData["code"] = DFWWebCommandCallBackCodeType.NotFound.rawValue
            if(body[kDWFWebCallbackTag] != nil){
                respData[kDWFWebCallbackTag] = body[kDWFWebCallbackTag]
            }
            DFWWebCommand.sharedCommand.commandJsCompletedCallback(respData: respData,
                                                                   webView: webView)
        }
        
    }
    
    
    /// 主动发送事件给js
    /// - Parameters:
    ///   - eventName:      事件名称
    ///   - params:         数据参数
    ///   - webView:        当前页面
    @objc dynamic public class func disPatchEvent(event name: String,
                                    params: Dictionary<String, Any>,
                                    webView: DFWWebView?) {
        if name.count > 0 {
            var codeString = "dfwAppclass.DFWEvent.__dispatchEvent( '\(name)', "
            if let data = try? JSONSerialization.data(withJSONObject: params, options: []),
               let paramsStr = String(data: data, encoding: String.Encoding.utf8) {
                codeString += "\(paramsStr))"
            }else {
                codeString += "{})"
            }
            webView?.evaluateJavaScript(codeString) { (result, err) in
                if(err != nil){}
            }
        }
    }
    
    
    //MARK: DFWWebCommandDelegate
    @objc dynamic func commandJsCompletedCallback(respData: Dictionary<String, Any>, webView: DFWWebView?) {
        if(webView == nil){
            return
        }
        var jsParams: Dictionary<String, Any>? = nil
        if(JSONSerialization.isValidJSONObject(respData)){
            jsParams = respData
        }else{
            jsParams = Dictionary<String, Any>()
            jsParams!["code"] = DFWWebCommandCallBackCodeType.DataFormatFailure.rawValue
            if(respData[kDWFWebCallbackTag] != nil){
                jsParams![kDWFWebCallbackTag] = respData[kDWFWebCallbackTag]
            }
        }
        let data = try? JSONSerialization.data(withJSONObject: jsParams!, options: [])
        let codeStr = String(data: data!, encoding: String.Encoding.utf8)
        let codeString = "dfwNativeCallback( \(codeStr!) )"
        webView?.evaluateJavaScript(codeString) { (result, err) in
            if(err != nil){
                print("webCommand error: \(String(describing: err))" )
                
            }
            
        }
    }

}
