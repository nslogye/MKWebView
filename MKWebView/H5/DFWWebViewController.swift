//
//  DFWWebViewController.swift
//  DongFuWang
//
//  Created by lianggq on 2020/10/24.
//

import UIKit
import WebKit
import RxSwift

/// web页面返回消失
let NOTIFICATION_WEBPAGEBACKDEINIT     = "NOTIFICATION_WEBPAGEBACKDEINIT"
/// webview强制刷新
let kRefreshWebView = "refreshWebView"
/// webview强制刷新（登录刷新）
let NOTIFICATION_WEB_RELOAD = "NOTIFICATION_WEB_RELOAD"
/// showloading类型
@objc
enum DFWWebShowLoadingEnum: Int {
    /// 不使用loading
    case none = 0
    /// 模态加载动画
    case mode = 1
    /// 局部加载动画
    case loading = 2
    /// 带logo的加载动画
    case logoLoading = 3
}

class DFWWebViewController: DFWBaseRootViewController,WKNavigationDelegate {
    /// 是否有右上角显示更多
    @objc public var isShowMoreContent = true
    
    @objc var requestUrlStr: String?
    
    @objc var webTitle: String?
    
    @objc var popToRoot : Bool = false
    /// showloading类型
    @objc var showLoadingType: DFWWebShowLoadingEnum = .none
    // 产品要一个监控8s的状态
    private var ob8S: Disposable?
    // 产品要一个监控30s的状态
    private var ob30S: Disposable?
    
    @objc private lazy var webView: DFWWebView = {
        let webView = DFWWebViewPool.shared.getReusedWebView(forHolder: self)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }()
    @objc private lazy var progressView: UIProgressView = {
        let proView = UIProgressView()
        proView.tintColor = DFW_ColorFrom16(h: 0x2C7DFF)
        proView.trackTintColor = UIColor.white // 进度条背景色
        return proView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.webTitle = DFWWebViewController.appearTitle
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// dealloc方法
    deinit {
        // 销毁观察者
        self.destructionObserver()
        /// 使用完成之后，webView持有者销毁，则放回可复用池中
        DFWWebViewPool.shared.tryCompactWeakHolders()
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "canGoBack")
        self.webView.removeObserver(self, forKeyPath: "title")
//        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NOTIFICATION_WEB_RELOAD), object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: kRefreshWebView), object: nil)
        print("webvc deinit")
    }
    
    //MARK: Lify Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setTopBarStyle(topBarStyle: DFWTopBarStyle.DFWTopBarStyleTitleWithLeftButtonAndCloseButtonAndRightButton)
        self.navigationBar.setLeftButtonImage(leftButtonImage: UIImage.init(named: "dfs_return_black_icon"))
        self.navigationBar.setCloseButtonImage(closeButtonImage: UIImage.init(named: "dfw_web_close"))
        
        self.navigationBar.closeButton.isHidden = !self.webView.canGoBack
        self.respondsToLeftEvent {[weak self] (button) in
            self?.goBackClick()
        }
        self.respondsToCloseEvent { [weak self] (button) in
            self?.close()
        }
        
        self.webView.webProxy = self
        self.webView.containerVc = self
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationMaxY)
            make.left.right.equalTo(self.view)
            make.height.equalTo(1.0)
        }
        self.webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationMaxY)
            make.left.right.bottom.equalToSuperview()
        }
        self.canPopWithGesture(true)
       
        self.loadWeb(urlStr: self.requestUrlStr)
        
        // 网络异常界面
        self.view.addSubview(errorView)
        errorView.refreshAgain { [weak self] in
            let isConnection = DFWAppNetworkMonitor.isConnection()
            if isConnection {
                self?.errorView.isHidden = true
            } else {
                LoadingHUD.showStatus(message: "title.network.fail", view: nil)
            }
            self?.refresh()
            /// 网络监控
            self?.slowNetworkMonitor()
            self?.showLoading()
        }
        
        // 强制关闭暗黑模式
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWebView), name: Notification.Name(rawValue: kRefreshWebView), object: nil)
        
        /// 网络监控
        slowNetworkMonitor()
        webTitle = "东方福利网"
        self.setItemTitle(itemTitle: self.webTitle ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.setJsCurrentPageSelf()
        self.canPopWithGesture(self.isRecordCanPopGestureRecognizer)
        if self.webView.url != nil {
            DFWWebCommand.disPatchEvent(event: "appPageWillAppearEvent", params: [:], webView: self.webView)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.removeJsUserSelf()
        self.canPopWithGesture(true)
        if self.webView.url != nil {
            DFWWebCommand.disPatchEvent(event: "appPageWillDisappearEvent", params: [:], webView: self.webView)
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 销毁观察者
        self.destructionObserver()
    }
    
   
    
    /// 刷新weiview
    @objc dynamic private func refreshWebView() {
        DispatchQueue.main.after(0.5) {
            self.webView.reload()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("------->web标题:\(webView.title ?? "")")
        if keyPath == "estimatedProgress" {
            let estimatedProgress = self.webView.estimatedProgress
            self.progressView.setProgress(Float(estimatedProgress), animated: true)
            self.progressView.alpha = 1.0
            if estimatedProgress >= 0.75 {
                self.progressView.setProgress(1.0, animated: true)
                UIView.animate(withDuration: 0.3) {
                    self.progressView.alpha = 0.0
                } completion: { (finish) in
                    self.progressView.isHidden = true
                }
            }
        }else if keyPath == "title" {
            if (self.webView.title ?? "").count > 0 {
                self.setItemTitle(itemTitle: self.webView.title ?? "")
            }
        }else if keyPath == "canGoBack" {
            self.navigationBar.closeButton.isHidden = !self.webView.canGoBack
            self.canPopWithGesture(!self.webView.canGoBack)
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: Public Action
    @objc dynamic public func close() {
        if let nav = self.navigationController,
           nav.viewControllers.count > 0 {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: {})
        }
    }
    
    @objc dynamic public func goBack() {
        if self.popToRoot == true {
            DFWManager.popToRootViewController(animated: true)
        }else{
            if self.webView.canGoBack {
                self.webView.goBack()
                /// app回退事件上报
                DispatchQueue.main.after(0.5) {
                    DFWWebCommand.disPatchEvent(event: "appPageWillGoBackEvent", params: [:], webView: self.webView)
                }
                
            }else {
                self.close()
            }
        }
        
    }
    
    @objc dynamic public func refresh() {
        if self.webView.canGoBack {
            //有历史记录
            self.webView.reload()
        }else {
            self.loadWeb(urlStr: requestUrlStr)
        }
    }
    
    //MARK: 是否可以系统右滑动返回，
    @objc private var isRecordCanPopGestureRecognizer: Bool = true
    @objc dynamic private func canPopWithGesture(_ isCanPop: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isCanPop
        self.isRecordCanPopGestureRecognizer = isCanPop
    }
    
    @objc dynamic private func loadWeb(urlStr: String?) {
//        self.progressView.isHidden = false
//        self.progressView.setProgress(0.0, animated: false)
        self.webView.loadString(urlStr: urlStr)
    }
    
    @objc dynamic private func goBackClick() {
        var jsBackCode = ""
        jsBackCode += "if(!window.__dfwAppGobackFunc) { \n"
        jsBackCode += "  window.__dfwAppGobackFunc = function() { \n"
        jsBackCode += "    if(window.dfwAppclass) { \n"
        jsBackCode += "       return dfwAppclass.DFWUtils.isUseH5Historyback(); \n"
        jsBackCode += "    }else { \n"
        jsBackCode += "       return 0; \n"
        jsBackCode += "    } \n"
        jsBackCode += "  } \n"
        jsBackCode += "} \n"
        jsBackCode += "window.__dfwAppGobackFunc()"
        self.webView.evaluateJavaScript(jsBackCode) {[weak self] (result, err) in
            if err != nil {
                self?.goBack()
            }else {
                if (result as? Int) == 0 {
                    self?.goBack()
                }
            }
        }
    }
    
    @objc dynamic private func handlerWebError(_ webView: WKWebView, error: Error) {
        let ocErr = error as NSError
        if  ocErr.code == NSURLErrorNotConnectedToInternet ||
            ocErr.code == NSURLErrorCannotFindHost ||
            ocErr.code == NSURLErrorTimedOut  {
            //断网、host找不到、超时 提示网络失败
            errorView.isHidden = false
        }
        
        print("web error code = \(ocErr.code)")
    }
    
    /// webview刷新
    @objc dynamic private func reloadWebView() {
        // 销毁观察者
        self.destructionObserver()
        self.webView.reload()
    }
    
}



extension DFWWebViewController {
    
    @objc private static var appearTitle: String? = ""
    
    @objc dynamic public class func setAppearanceTitle(_ title: String?) {
        self.appearTitle = title
    }
    
}

// MARK: WKWebViewDelegate
extension DFWWebViewController {
    // 页面开始加载时调用
    @objc dynamic func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("--->页面开始加载时调用")
        
    }
    // 当内容开始返回时调用
    @objc dynamic func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("--->当内容开始返回时调用")
//        hideLoading()
    }
    
    // 页面加载完成之后调用
    @objc dynamic func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("--->页面加载完成之后调用")
        self.destructionObserver()
        //hideLoading()
        
        //debug
        startH5Debug()
        
        //本地种session storage
        let jsBackCode = "window.sessionStorage.setItem('sessionInit','1')"
        self.webView.evaluateJavaScript(jsBackCode) {(result, err) in
            
        }
    }
    // 页面加载失败时调用
    @objc dynamic func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("--->web didFail error \(error)")
       
//        hideLoading()
        self.handlerWebError(webView, error: error)
    }
    
    @objc dynamic func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        hideLoading()
        print("web didFailProvisionalNavigation error \(error)")
        self.handlerWebError(webView, error: error)
    }
 
    @objc dynamic func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        //判断本地埋的session的值是否还存在，不存在直接回退到APP原生页面
        let sessionInit = "window.sessionStorage.getItem('sessionInit')"
        self.webView.evaluateJavaScript(sessionInit) {(result, err) in
            let sessionInit = result as? String ?? ""
            if sessionInit == "1" {
                self.reloadWebView()
            }else{
                //回退到原生页面
                DFWManager.popToRootViewController(animated: true)
            }
           
        }
    }
    @objc dynamic private func startH5Debug() {
        // eruda
//        if let isOpenEruda = DFWUserDefault.getUserDefault(key: OPENH5ERUDA),
//            isOpenEruda == "1" {
//            if let path = Bundle.main.path(forResource: "eruda", ofType: "js") {
//                if let fileName = try? String(contentsOfFile: path, encoding: .utf8) {
//                    self.webView.evaluateJavaScript(fileName) { _, _ in
//                    }
//                }
//            }
//        }
//        // vconsole
//        if let isOpenVConsole =  DFWUserDefault.getUserDefault(key: OPENH5VCONSOLE) {
//            if isOpenVConsole == "1"{
//                if let path = Bundle.main.path(forResource: "vconsole", ofType: "js"){
//                    if let fileName = try? String.init(contentsOfFile: path, encoding: .utf8){
//                        self.webView.evaluateJavaScript(fileName) {(result, err) in
//                            
//                        }
//                    }
//                }
//            }
//        }
    }
}
//MARK: -- 慢网络处理 --
extension DFWWebViewController {
    /// 网络监控
    @objc dynamic func slowNetworkMonitor() {
        self.destructionObserver()
        
        ob8S = PublishSubject<String>().timeout(RxTimeInterval.seconds(8), scheduler: MainScheduler.instance).subscribe { event in
            switch event {
            case let .error(error):
                LoadingHUD.showWithStatus(status: "network_slow_please_patient")
                print("------》8s: error:\(error)")
            default:
                break
            }
        }
        
        
        ob30S = PublishSubject<String>().timeout(RxTimeInterval.seconds(30), scheduler: MainScheduler.instance).subscribe { [weak self]event in
            switch event {
            case let .error(error):
                self?.errorView.isHidden = false
                print("------》30s: error:\(error)")
            default:
                break
            }
        }

    }
    
    /// 销毁观察者
    @objc dynamic func destructionObserver() {
        ob8S?.dispose()
        ob30S?.dispose()
    }
}

//MARK: -- 加载框的处理 --
extension DFWWebViewController {
    /// showLoading
    @objc dynamic func showLoading() {
        // 【产品】没有网络的时候，不要loading
        let isConnection = DFWAppNetworkMonitor.isConnection()
        guard isConnection else {
            self.destructionObserver()
            return
        }
        
        switch showLoadingType {
        case .none:
            break
        case .mode:
            LoadingHUD.showModeLoading(view: self.view)
        case .loading:
            LoadingHUD.showAnimationLoading(view: self.view)
        case .logoLoading:
            LoadingHUD.showLogoLoading(view: self.view)
        }
        
        // 在使用加载框的时候，不知道什么时候h5会出现loading，所以产品暂时讨论刚开始隐藏webview，等didFinish的时候在出现
        /// 隐藏webview
        let isShow = showLoadingType == .none
        webView.isHidden = !isShow
    }
    /// 隐藏加载框
    @objc dynamic func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            LoadingHUD.hideHUDInView(view: self.view)
            // 销毁观察者
            self.destructionObserver()
            self.webView.isHidden = false
        }
    }
 
}
