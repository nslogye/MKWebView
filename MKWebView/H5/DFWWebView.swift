//
//  DFWWebView.swift
//  DongFuWang
//
//  Created by lianggq on 2020/10/24.
//

import UIKit
import WebKit

 
fileprivate extension WKWebView {
    
    @available(iOS 11.0, *)
    @objc dynamic class func initializeMethod(){
        let originalSelector = #selector(self.handlesURLScheme(_:))
        let swizzledSelector = #selector(self.dfwHandlesURLScheme(_:))
        let originalMethod = class_getClassMethod(self, originalSelector)
        let swizzledMethod = class_getClassMethod(self, swizzledSelector)
        //
        if(originalMethod != nil && swizzledMethod != nil){
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    @objc dynamic private class func dfwHandlesURLScheme(_ urlScheme: String) ->Bool{
        let urlLower = urlScheme.lowercased()
        if(urlLower == "dfwapp" || urlLower == "dfwapps"){
            return false   //这里让返回false,应该是默认不走系统断言或者其他判断啥的
        }
        return self.dfwHandlesURLScheme(urlScheme)
    }
}


fileprivate let AppUserAgentFlag = "-MAX-APP"

fileprivate let AppWebSetNoCacheFlag = "noCache=true"

fileprivate let AppWebHideTitleFlag = "hideTitle=true"

fileprivate let APPWebTempTag: Int = 10101

fileprivate let APPWebFileTypes: [String] = ["pdf","doc","ppt","xls"]

public let AppToCookieJSRequestURL = "http://static.dongfangfuli.com/info/bridge/1.0/prd/app_bridge.min.js"


open class DFWWebView: WKWebView,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    weak var holderObject: AnyObject?
    
    @objc public var KUrlCodingReservedCharacters = "!*'();:|@&=+$,/?%#[]{}"
//
    @objc public weak var webProxy: WKNavigationDelegate?
    
    @objc weak var containerVc: DFWBaseRootViewController?
    //
//    public class func getWebView() -> DFWWebView {
//        return DFWWebView(frame: CGRect.zero)
//    }
    
    //临时预加载使用
    @objc private static var temps: [DFWWebView] = []
    @objc public static var preTemp: DFWWebView {
        let webView = DFWWebView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        webView.tag = APPWebTempTag
        self.temps.append(webView)
        return webView
    }
    @objc public static var configuration: WKWebViewConfiguration{
        struct DFWWebConfigStruct {
            static var configIns: WKWebViewConfiguration? = nil
        }
        var configuration = DFWWebConfigStruct.configIns
        if(configuration == nil){
            configuration = WKWebViewConfiguration.init()
            let preferences = WKPreferences.init()
            preferences.javaScriptCanOpenWindowsAutomatically = true
            preferences.javaScriptEnabled = true
            configuration?.preferences = preferences
            let userContent = WKUserContentController.init()
            configuration?.userContentController = userContent
            if #available(iOS 11.0, *) {
                WKWebView.initializeMethod()
                let handler = DFWURLSchemeHandler.init()
                configuration?.setURLSchemeHandler(handler, forURLScheme: "dfwapp")
                configuration?.setURLSchemeHandler(handler, forURLScheme: "dfwapps")
            }
            configuration?.websiteDataStore = WKWebsiteDataStore.default()
            DFWWebConfigStruct.configIns = configuration
        }
        configuration?.userContentController.removeAllUserScripts()
        return configuration!
    }
    //userAgent
    @objc private static var userAgent: String?
    @objc private var userAgentWeb: WKWebView?
    
    //MARK: Override
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(frame: CGRect){
        self.init(frame: frame, configuration: nil)
        self.backgroundColor = DFW_ColorFromHexColor(hexColor: "#FFFFFF")
        // 允许调试
//        if #available(iOS 16.4, *) {
//            if let isOpen = DFWUserDefault.getUserDefault(key: kOpenDebugSafari),
//               isOpen == "1"{
//                self.isInspectable = true
//            } else {
//                self.isInspectable = false
//            }
//        }
        
    }
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration?) {
        let config = (configuration != nil) ? configuration! : Self.configuration
        super.init(frame: frame, configuration: config)
        //
        self.scrollView.bounces = true
        self.backgroundColor = UIColor.white
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.navigationDelegate = self
        self.uiDelegate = self
        self.allowsLinkPreview=false
        //为解决ios12 useragent不生效问题
        if Self.userAgent != nil {
            let version = "-" + DFWOperationToolsFile.getNowVersion()
            let deviceNo = "-" + DFWOperationToolsFile.getDeviceId()
            self.customUserAgent = Self.userAgent! + AppUserAgentFlag + version + deviceNo
        }else {
            let fakeView = WKWebView.init(frame: frame, configuration: config)
            self.userAgentWeb = fakeView
            fakeView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
                if error == nil && result != nil{
                    if let agent = result as? String {
                        Self.userAgent = agent
                        let version = "-" + DFWOperationToolsFile.getNowVersion()
                        let deviceNo = "-" + DFWOperationToolsFile.getDeviceId()
                        let userAgent = agent + AppUserAgentFlag + version + deviceNo
                        self?.customUserAgent = userAgent
                    }
                }
                self?.userAgentWeb = nil
            }
        }
    }
    
    //MARK: Public Method
    @objc dynamic public func setJsCurrentPageSelf(){
        weak var wekSelf = self
        self.removeJsUserSelf()
        self.configuration.userContentController.add(wekSelf!, name: "DFWWebKitHander")
    }
    
    @objc dynamic public func removeJsUserSelf(){
        self.configuration.userContentController.removeScriptMessageHandler(forName: "DFWWebKitHander")
    }
    
    
    @discardableResult
    @objc dynamic public func loadString(urlStr: String?) -> WKNavigation? {
//        if(urlStr == nil){
//            return nil
//        }
//        var urlUT8 = urlStr!
//        if urlStr!.contains("%") == false { //不包含则去encoding
//            var charSet = CharacterSet.urlQueryAllowed
//            charSet.insert(charactersIn: "#")
//            guard let encodingStr = urlStr?.addingPercentEncoding(withAllowedCharacters: charSet) else {
//                return nil
//            }
//            urlUT8 = encodingStr
//        }
        guard let _urlString: String = urlStr else {
            return nil
        }
        var url : URL?
        if(_urlString.hasPrefix("file") || _urlString.hasPrefix("/")){
            // 加载本地路径
            let urlUT8 = uft8String(string: _urlString)
            url = URL.init(fileURLWithPath: urlUT8)
        }else {
            // 加载远程url
//            let redirectUrlString: String = redirect302Url(url: _urlString)
            url = URL.init(string: _urlString)
//            url = URL.init(string: redirectUrlString)
        }
        return self.loadRequestWith(url: url)
    }
//    /// 302重定向url
//    @objc dynamic func redirect302Url(url: String) -> String {
//        let urlPath = DFWDomainEnvManager.getFullPath(relativePath: API_Redirect)
//        var redirectUrlString = urlPath
//        let urlencodeString: String = urlEncoded(string: url)
//        // 拼接deviceid
//        if let deviceId = APPConfigureCacheModel.getDeviceId(),
//            deviceId.count > 0 {
//            redirectUrlString +=  "?" + "dfDeviceId=\(deviceId)" + "&redirectUrl=\(urlencodeString)" + "&unifyMall=\(1)"
//        } else {
//            redirectUrlString += "?" + "redirectUrl=\(urlencodeString)" + "&unifyMall=\(1)"
//        }
//        // 是否灰度
//        let isGray = DFWAPPConfigure.share.getAPPGray()
//        let token = DFWUserInfoManager.singletion().getLoginToken()
//        // 写cookie
//        if isGray,
//            let cookieModel = DFWAPPConfigure.share.mallGrayModel {
//            let cookieString = cookieModel.getCookieString()
//            redirectUrlString += "&" + cookieString
//            let unionCode: String = cookieModel.mallUnionCode
//            
//            if !cookieString.contains("company=")
//                && kStringIsEmpty(str: unionCode) == false {
//                redirectUrlString += "&company=\(unionCode)"
//            }
//            
//            if !cookieString.contains("dfflone_union_")
//                && kStringIsEmpty(str: unionCode) == false
//                && kStringIsEmpty(str: token) == false{
//                redirectUrlString += "&dfflone_union_\(unionCode)=\(token)"
//            }
//            
//            if !cookieString.contains("dfflone=")
//                && kStringIsEmpty(str: token) == false {
//                redirectUrlString += "&dfflone=\(token)"
//            }
//        }
//
//        // 如果没有拼接dfflone 需要拼接token
//        if !redirectUrlString.contains("dfflone=")
//            && kStringIsEmpty(str: token) == false {
//            redirectUrlString += "&dfflone=\(token)"
//        }
//        if DFWAPPConfigure.share.getAPPGray() {
//            redirectUrlString += "&dfWebUnifyShop=\(true)"
//        } else {
//            redirectUrlString += "&dfWebUnifyShop=\(false)"
//        }
//        // 网关灰度
//        if let isOpenGray =  DFWUserDefault.getUserDefault(key: OPENGRAY), isOpenGray == "1"{
//            redirectUrlString += "&tag_group=gray"
//        }
//        
//        print("原始Url:\(url)")
//        print("302重定向url：\(redirectUrlString)")
//        return redirectUrlString
//    }
    
    /// utf8
    @objc dynamic func uft8String(string: String) -> String {
        var urlUT8 = string
        if urlUT8.contains("%") == false { //不包含则去encoding
            var charSet = CharacterSet.urlQueryAllowed
            charSet.insert(charactersIn: "#")
            guard let encodingStr = urlUT8.addingPercentEncoding(withAllowedCharacters: charSet) else {
                return ""
            }
            urlUT8 = encodingStr
        }
        return urlUT8
    }
    /// url编码
    @objc dynamic func urlEncoded(string: String) -> String {
        let encodeUrlString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: KUrlCodingReservedCharacters).inverted)
        return encodeUrlString ?? string
    }
    
    @objc dynamic private func loadRequestWith(url: URL?) -> WKNavigation? {
        if(url == nil) {
            return nil
        }
        let lower = url!.absoluteString.lowercased()
        var policy: URLRequest.CachePolicy = .useProtocolCachePolicy
        if #available(iOS 13, *) {
            // ios 校验本地和服务数据是否相同，否则请求服务
//            policy = .reloadRevalidatingCacheData
        }
        //缓存
        if lower.contains(AppWebSetNoCacheFlag) || !DFWAppNetworkMonitor.isConnection() {
            policy = .reloadIgnoringLocalCacheData
        }
        //隐藏title
        if lower.contains(AppWebHideTitleFlag) {
            self.containerVc?.setNavigationHidden(nagationHidden: true)
        }
        
         
        //加载
        var request = URLRequest.init(url: url!, cachePolicy: policy, timeoutInterval: 8.0)
//        // 网关灰度
//        if let isOpenGray = UserDefault_get(key: OPENGRAY) as? String, isOpenGray == "1"{
//            request.setValue("gray", forHTTPHeaderField: "tag-group")
//        }
        
        
        request.httpShouldHandleCookies = true
        return self.load(request)
    }
    
    
    //MARK: WKWebViewDelegate
    @objc dynamic public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        print("---->decidePolicyFor:\(navigationAction.request.url)")
        if let url = navigationAction.request.url {
            //iTunes  scheme
            if url.host == "itunes.apple.com" || url.scheme?.hasPrefix("http") == false {
                let appURL = url
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    decisionHandler(WKNavigationActionPolicy.cancel)
                    return
                }
            }
            //soft file
            let extName = url.pathExtension
            var isFoundForFileType: Bool = false
            for fileExt in APPWebFileTypes {
                if extName.lowercased().contains(fileExt) {
                    isFoundForFileType = true
                    break;
                }
            }
            if isFoundForFileType {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(WKNavigationActionPolicy.cancel)
                    return
                }
            }
            //解决html <a>标签的属性target = "_blank"无法跳转问题
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
                
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
        self.webProxy?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
        print("--->web response url = \(navigationResponse.response.url?.absoluteString ?? "")")
        if let response = navigationResponse.response as? HTTPURLResponse {
//            let code = response.statusCode
//            if code == 404 && response.url?.host != "api.growingio.com" { //404
//                let url404 = DFWDomainEnvManager.getStaticPullPath(relativePath: "/info/404.html")
//                self.loadString(urlStr: url404)
//               decisionHandler(WKNavigationResponsePolicy.cancel)
//                return
//            }
        }
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.webProxy?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.webProxy?.webView?(webView, didCommit: navigation)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if webView.tag == APPWebTempTag {
            self.removeShareWeb(webView)
        }
        self.webProxy?.webView?(webView, didFinish: navigation)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if webView.tag == APPWebTempTag {
            self.removeShareWeb(webView)
        }
        self.webProxy?.webView?(webView, didFail: navigation, withError: error)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if webView.tag == APPWebTempTag {
            self.removeShareWeb(webView)
        }
        self.webProxy?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
    
//    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        // 判断服务器采用的验证方法
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//            if challenge.previousFailureCount == 0 {
//                // 如果没有错误的情况下 创建一个凭证，并使用证书
//                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//                completionHandler(.useCredential, credential)
//            } else {
//                // 验证失败，取消本次验证
//                completionHandler(.cancelAuthenticationChallenge, nil)
//            }
//        } else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//        }
//    }
    
    @objc dynamic public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.webProxy?.webViewWebContentProcessDidTerminate?(webView)
    }
    
    @objc dynamic private func removeShareWeb(_ web: WKWebView) {
        if let webView = web as? DFWWebView,
           let index = Self.temps.index(of: webView) {
            Self.temps.remove(at: index)
        }
    }

    //MARK: WKUIDelegate
    @objc dynamic public func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        //window.alert()
        completionHandler()
    }
    
    @objc dynamic public func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        //window.confirm()
        completionHandler(true)
    }
    
    @objc dynamic public func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        completionHandler(defaultText)
    }
    
    
    //MARK: WKScriptMessageHandler
    @objc dynamic public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DFWWebCommand.webCommand(didReceive: message.body, webView: self)
    }
    
    //
    deinit {
        // 持有者置为nil
        holderObject = nil
        print("webView deinit")
    }
 
}
