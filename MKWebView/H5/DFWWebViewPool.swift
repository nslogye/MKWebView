//
//  DFWWebViewPool.swift
//  DFMaxStore
//
//  Created by qianduan2731 on 2023/7/10.
//

import UIKit
/// tab页加载完成之后通知webview缓冲池，初始化webview
let kTabControllerInitSuccessNotiKey = "kTabControllerInitSuccessNotiKey"

class DFWWebViewPool: NSObject {
    // 当前有被页面持有的webview
    fileprivate var visiableWebViewSet = Set<DFWWebView>()
    // 回收池中的webview
    fileprivate var reusableWebViewSet = Set<DFWWebView>()

    public static let shared = DFWWebViewPool()
    
    public override init() {
        super.init()
        // 监听内存警告，清除复用池
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveMemoryWarningNotification),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
        // 监听首页初始化完成
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mainControllerInit),
                                               name: NSNotification.Name(rawValue: kTabControllerInitSuccessNotiKey),
                                               object: nil)
    }
    
    deinit {
        // 清除set
    }
}
// MARK: Observers
extension DFWWebViewPool {
    
    @objc dynamic func mainControllerInit() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            self.prepareReuseWebView()
        }
    }
    /// 预备一个空的webview
    @objc dynamic func prepareReuseWebView() {
        guard reusableWebViewSet.count <= 0 else { return }
        let webview = DFWWebView(frame: CGRect.zero)
        self.reusableWebViewSet.insert(webview)
    }
    ///内存溢出之后删除复用池里的webView
    @objc fileprivate func didReceiveMemoryWarningNotification() {
        self.clearAllReusableWebViews()
    }
}


// MARK: 复用池管理
extension DFWWebViewPool {
    
    /// 获取可复用的webView
    @objc dynamic func getReusedWebView(forHolder holder: AnyObject?) -> DFWWebView {
        assert(holder != nil, "DFWWebView holder不能为nil")
        guard let holder = holder else {
            return DFWWebView(frame: CGRect.zero)
        }
        let webView: DFWWebView
        if reusableWebViewSet.count > 0 {
            // 缓存池中有
            webView = reusableWebViewSet.randomElement()!
            //删除缓存池中老的webview
            reusableWebViewSet.remove(webView)
            //将老的webview放入当前页面中
            visiableWebViewSet.insert(webView)
            //再创建一个新的webview对象放在缓冲池中，预留下次使用
            let newWebView = DFWWebView(frame: CGRect.zero)
            reusableWebViewSet.insert(newWebView)
            
        } else {
            // 缓存池没有，创建新的
            webView = DFWWebView(frame: CGRect.zero)
            visiableWebViewSet.insert(webView)
        }
        
        webView.holderObject = holder
        
        return webView
    }
    /// 使用中的webView持有者已销毁，webview内存释放掉
    @objc dynamic func tryCompactWeakHolders() {
        let shouldReusedWebViewSet = visiableWebViewSet.filter{ $0.holderObject == nil }
        for webView in shouldReusedWebViewSet {
            visiableWebViewSet.remove(webView)
        }
    }
    
    /// 移除并销毁所有复用池的webView
    @objc dynamic func clearAllReusableWebViews() {
        reusableWebViewSet.removeAll()
    }
}

