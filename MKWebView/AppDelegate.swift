//
//  AppDelegate.swift
//  MKWebView
//
//  Created by qianduan2731 on 2023/12/23.
//

import UIKit

@main
class MKAppDelegate: UIResponder, UIApplicationDelegate {
    @objc var window: UIWindow?
    @objc dynamic func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        //初始化window
        initWindow()
        return true
    }
    // 初始化window
    @objc dynamic func initWindow() {
        let lanchVc = ViewController.init()
        self.window?.rootViewController = DFWBaseRootNavigatController.init(rootViewController: lanchVc)
        self.window?.makeKeyAndVisible()
    }

    
    //后台下载完毕后会调用（我们将其交由下载工具类做后续处理）
    @objc dynamic func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        
    }
    
   
    @objc dynamic func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    @objc dynamic func applicationDidEnterBackground(_ application: UIApplication) {

    }
    @objc dynamic func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    }

    @objc dynamic func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    @objc dynamic func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
   
    @objc dynamic func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("\(url.absoluteString)")
//        if url.scheme?.lowercased() == "dfflmax" {
//            if let query = url.query {
//                let params = query.removingPercentEncoding ?? query
//                let data = params.data(using: .utf8)!
//                if let pageDatas = (try? JSONSerialization.jsonObject(with: data)) as? Dictionary<String, Any> {
//                    DispatchQueue.main.after(2.0) {
//                        //如果当前页面是登录页，则不跳转链接
//                        guard let currentVC = DFWManager.findCurrentViewController() else { return }
//                        if !currentVC.isKind(of: DFSLoginViewController.self){
//                            DFWBaseOpenURL.handleOpenInPageDatas(pageDatas)
//                        }
//                    }
//                }
//            }
//        }
//        
//        if url.host == "safepay"{//支付宝
//            //支付回调
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback:{ (resultDic) in
//                AliPayManager.handlePayResult(resultDic)
//            })
//            return true
//        }
//        
//        if url.scheme?.hasPrefix("wx") == true { //微信支付
//            return WXApi.handleOpen(url,delegate:WXApiManager.shared)
//        }
//        if (Growing.handle(url)) {
//            return true
//        }
//        
//        if DFWShareManager.application(open: url, options: options) {
//            return true
//        }
        return false
    }
    
    //MARK: UniversalLink
    @objc dynamic func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if let webURL = userActivity.webpageURL {
//            if webURL.path.contains("app/wx") { //微信渠道过来的
//                if webURL.path.contains("pay"){
//                    //走的支付
//                    if WXApi.handleOpenUniversalLink(userActivity, delegate: WXApiManager.shared) {
//                        return true
//                    }
//                }else {
//                    //分享
//                    if DFWShareManager.application(continue: userActivity) {
//                        return true
//                    }
//                }
//            }
//        }
        return false
    }
    
}

