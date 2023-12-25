//
//  DFControlTool.swift
//  DongFuWang
//
//  Created by sunshine on 2023/4/26.
//

import UIKit
 
public
class DFWControlTool: NSObject {
    /// 获取根window
    @objc dynamic public func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .last?.windows
                .filter { $0.isKeyWindow }
                .last
        } else {
            window = UIApplication.shared.keyWindow
        }
    
        if window == nil {
            window = UIApplication.shared.keyWindow
        }
        
        return window
    }
    /// 获取顶层Nav 根据window
    @objc dynamic public func currentNavigationController() -> UINavigationController? {
        return currentViewController()?.navigationController
    }

    
    /// 获取顶层VC 根据window
    @objc dynamic public func currentViewController() -> UIViewController? {
        var window = getKeyWindow()
        // 是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows where windowTemp.windowLevel == UIWindow.Level.normal {
                window = windowTemp
                break
            }
        }
        let vc = window?.rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }

    /// 获取最底层presentingController
    @objc dynamic public func getRootPresentingController(vc: UIViewController) -> UIViewController? {
        var rootViewController = vc.presentingViewController
        while (rootViewController?.presentingViewController != nil) {
            rootViewController = rootViewController?.presentingViewController
        }
        return rootViewController
    }
    
    
    /// 根据控制器获取 顶层控制器 递归
    private func getCurrentViewController(withCurrentVC VC: UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            // modal出来的 控制器
            return getCurrentViewController(withCurrentVC: presentVC)
        } else if let splitVC = VC as? UISplitViewController {
            // UISplitViewController 的跟控制器
            if splitVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            } else {
                return VC
            }
        } else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if tabVC.viewControllers != nil {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            } else {
                return VC
            }
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            if naiVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC: naiVC.visibleViewController)
            } else {
                return VC
            }
        } else {
            // 返回顶控制器
            return VC
        }
    }
  
     
}
extension DispatchQueue {
    func after(_ delay: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: execute)
    }
}
