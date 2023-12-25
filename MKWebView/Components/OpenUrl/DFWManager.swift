//
//  DFWUIManager.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/10/27.
//
 
import UIKit
// App通用跳转器协议
@objc protocol DFWUIManagerDelegate: NSObjectProtocol {
    /**
     *  如果页面通过storyboard创建，实现该方法，返回storyboard名
     *
     *  @return storyboard名
     */
    func storyboadName() -> String
    /**
     *  如果页面通过nib创建，实现该方法，返回storyboard名
     *
     *  @return nib名
     */
    func xibName() -> String
}

@objc protocol DFWUIManagerAnalysis: NSObjectProtocol {
    func setFrontPageNameArray(array: NSArray)
    func pageNameArray() -> NSArray
}

class DFWManager: NSObject {
    @objc dynamic static func viewControllerWithClass(cls: AnyClass) -> UIViewController? {
        var viewController: UIViewController?
        guard let newCls = cls as? UIViewController.Type else {
            return nil
        }
        if !newCls.isSubclass(of: UIViewController.self) {
            return nil
        }
        viewController = newCls.init()
        return viewController
    }

    // 私有方法__设置视图控制器相关参数
    @objc private dynamic static func setupViewController(viewController: UIViewController,
                                                   param: NSDictionary?) {
        if let _param = param {
            self.setupParamsForViewController(targetViewController: viewController, params: _param)
        }
        guard viewController.responds(to: Selector(("setFrontPageNameArray:"))) else {
            return
        }
        var pageNameArray = NSArray()
        let topViewController = currentNavigationController()?.topViewController
        if let tabbarController = topViewController as? UITabBarController {
            if let selectedViewController = tabbarController.selectedViewController,
               selectedViewController.responds(to: #selector(DFWUIManagerAnalysis.pageNameArray)),
               let pageArray = selectedViewController.perform(#selector(DFWUIManagerAnalysis.pageNameArray))?.takeRetainedValue() as? NSArray
            {
                pageNameArray = pageArray
            }
        }
        
        if (topViewController?.responds(to: #selector(DFWUIManagerAnalysis.pageNameArray))) != nil,
           let pageList = topViewController?.perform(#selector(DFWUIManagerAnalysis.pageNameArray))?.takeRetainedValue() as? NSArray
        {
            pageNameArray = pageList
        }
        
        viewController.perform(Selector(("setFrontPageNameArray:")), with: pageNameArray)
    }
    
    @objc private dynamic static func setupParamsForViewController(targetViewController: UIViewController, params: NSDictionary?) {
        let prototypeParams = NSMutableDictionary(capacity: 0)
        
        params?.enumerateKeysAndObjects { key, value, _ in
            if let newkey = key as? NSString {
                let newValue = value
                if (newValue as AnyObject).isKind(of: NSString.self) || (newValue as AnyObject).isKind(of: NSNumber.self) {
                    prototypeParams[newkey] = newValue
                    
                } else {
                    let upperKey = newkey.replacingCharacters(in: NSMakeRange(0, 1), with: newkey.substring(to: 1).uppercased())
                    let setMethod: Selector = NSSelectorFromString("set" + upperKey + ":")
                    if !targetViewController.responds(to: setMethod) {
                        return
                    }
                }
                
                targetViewController.setValue(newValue, forKeyPath: newkey as String)
            }
        }
//        targetViewController.mj_setKeyValues(prototypeParams)
    }
    /// 遍历得到变量列表并kvc给变量赋值
}

/// Push视图控制器
extension DFWManager {
    /**
     *  push视图控制器，根据类名
     *
     *  @param name 视图控制器类名
     */
    @objc dynamic static func showViewControllerWithName(name: String) {
        self.showViewControllerWithName(name: name, param: nil)
    }

    /**
     *  push视图控制器，根据类名
     *
     *  @param name  视图控制器类名
     *  @param param 视图控制器参数
     */
    @objc dynamic static func showViewControllerWithName(name: String, param: NSDictionary?) {
        self.showViewControllerWithName(name: name, param: param, animated: true)
    }

    /**
     *  push视图控制器，根据类名
     *
     *  @param name     视图控制器类名
     *  @param param    视图控制器参数
     *  @param animated 是否带动画
     */
    @objc dynamic static func showViewControllerWithName(name: String, param: NSDictionary?, animated: Bool) {
        // 1:动态获取命名空间
        guard let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        let spaceClsName = spaceName + "." + name // VCName:表示试图控制器的类名
        var vcClass: AnyClass? = DFWFixRunTimeHandle.classFromString(spaceClsName)
        if vcClass == nil {
            vcClass = DFWFixRunTimeHandle.classFromString(name)
        }
        guard let typeClass = vcClass as? UIViewController.Type else {
            print("vcClass不能当做UIViewController")
            return
        }
        self.showViewControllerWithClass(cls: typeClass, param: param, animated: animated)
    }

    /**
     *  push视图控制器，根据class
     *
     *  @param cls 视图控制器class
     */
    @objc dynamic static func showViewControllerWithClass(cls: AnyClass) {
        self.showViewControllerWithClass(cls: cls, param: nil)
    }

    /**
     *  push视图控制器，根据class
     *
     *  @param cls   视图控制器class
     *  @param param 视图控制器参数
     */
    @objc dynamic static func showViewControllerWithClass(cls: AnyClass, param: NSDictionary?) {
        self.showViewControllerWithClass(cls: cls, param: param, animated: true)
    }

    /**
     *  push视图控制器，根据class
     *
     *  @param cls      视图控制器class
     *  @param param    视图控制器参数
     *  @param animated 是否带动画
     */
    @objc dynamic static func showViewControllerWithClass(cls: AnyClass, param: NSDictionary?, animated: Bool) {
        guard let viewController: UIViewController = self.viewControllerWithClass(cls: cls) else {
            return
        }
        self.showViewController(viewController: viewController, param: param, animated: animated)
    }
    
    /**
     *  push视图控制器
     *
     *  @param viewController 视图控制器
     */
    @objc dynamic static func showViewController(viewController: UIViewController) {
        self.showViewController(viewController: viewController, param: nil)
    }

    /**
     *  push视图控制器
     *
     *  @param viewController 视图控制器
     *  @param param          视图控制器参数
     */
    @objc dynamic static func showViewController(viewController: UIViewController, param: NSDictionary?) {
        self.showViewController(viewController: viewController, param: param, animated: true)
    }

    /**
     *  push视图控制器
     *
     *  @param viewController 视图控制器
     *  @param param          视图控制器参数
     *  @param animated       是否带动画
     */
    @objc dynamic static func showViewController(viewController: UIViewController, param: NSDictionary?, animated: Bool) {
        self.setupViewController(viewController: viewController, param: param)
        guard let nav = self.currentNavigationController() else { return }
        nav.pushViewController(viewController, animated: animated)
    }
}

/// Pop视图控制器
extension DFWManager {
    /**
     *  pop当前视图控制器(默认animated为YES)
     *
     *  @return pop掉的视图控制器
     */
    @discardableResult
    @objc dynamic static func popViewController() -> UIViewController? {
        return self.popViewControllerAnimated(animated: true)
    }

    /**
     *  pop当前视图控制器
     *
     *  @param animated 是否带动画
     *
     *  @return pop掉的视图控制器
     */
    @discardableResult
    @objc dynamic static func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        if let viewController = self.currentNavigationController() {
            return viewController.popViewController(animated: animated)
        }
        guard let vc = self.findCurrentViewController() else { return nil }
        guard let navigationController = vc.navigationController as? DFWBaseRootNavigatController else { return nil }
        return navigationController.popViewController(animated: animated)
    }

    /**
     *  pop栈队列中指定视图(animated为YES)
     *
     *  @param cls 需要pop的视图控制器类
     *
     *  @return pop掉的视图控制器
     */
    @discardableResult
    @objc dynamic static func popToViewController(cls: AnyClass) -> UIViewController? {
        return self.popToViewController(cls: cls, animated: true)
    }

    /**
     *  pop栈队列中指定视图
     *
     *  @param cls 需要pop的视图控制器类
     *  @param animated            是否带动画
     *
     *  @return pop掉的视图控制器
     */
    @discardableResult
    @objc dynamic static func popToViewController(cls: AnyClass, animated: Bool) -> UIViewController? {
        var targetViewContrller: UIViewController?
        if let nav = self.currentNavigationController() {
            for vc in nav.viewControllers {
                if vc.isKind(of: cls) {
                    targetViewContrller = vc
                    nav.popToViewController(vc, animated: animated)
                    break
                }
            }
            return targetViewContrller!
        } else {
            return nil
        }
    }

    /**
     *  pop到栈底部视图(默认animated为YES)
     *
     *  @param animated pop动画
     */
    @objc dynamic static func popToRootViewController(animated: Bool) {
        if let nav = self.currentNavigationController() {
            nav.popToRootViewController(animated: animated)
        }
    }

    /**
     *  pop到栈底部视图(默认animated为YES)
     *
     *  @param index tabbarController的索引值
     */
    @objc dynamic static func popToRootViewController(index: Int) {
        self.popToRootViewController(index: index, animated: true)
    }

    /**
     *  pop到栈底部视图
     *
     *  @param index    tabbarController的索引值
     *  @param animated 是否带动画
     */
    @objc dynamic static func popToRootViewController(index: Int, animated: Bool) {
        guard let nav = self.currentNavigationController() else { return }
        nav.popToRootViewController(animated: animated)
        if let rootVc = self.rootViewController() as? UITabBarController {
            if (rootVc.viewControllers?.count ?? 0) > index {
                rootVc.selectedIndex = index
            }
        }
    }
    
    @objc dynamic static func popToRootIndexForClass(cls: UIViewController.Type, animated: Bool = true) {
        guard let rootVc = self.rootViewController() as? UITabBarController,
              let viewControllers = rootVc.viewControllers
        else {
            return
        }
        for (index, child) in viewControllers.enumerated() {
            if let navi = child as? UINavigationController,
               let first = navi.viewControllers.first
            {
                let clsStr = NSStringFromClass(cls)
                let firstStr = NSStringFromClass(first.classForCoder)
                if clsStr == firstStr {
                    rootVc.selectedIndex = index
                    navi.popToRootViewController(animated: animated)
                    break
                }
            }
        }
    }
    
    @objc dynamic static func popToRootIndexForClsName(clsName: String, animated: Bool = true) {
        var className = clsName
        if let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
            let spaceClsName = spaceName + "." + clsName
            className = spaceClsName
        }
        if let cls = DFWFixRunTimeHandle.classFromString(className) {
            self.popToViewController(cls: cls)
        }
    }
}

/// Present视图控制器
extension DFWManager {
    /**
     *  present视图控制器，根据类名
     *
     *  @param name 视图控制器类名
     */
    @objc dynamic static func presentViewControllerWithName(name: String) {
        self.presentViewControllerWithName(name: name, param: nil)
    }

    /**
     *  present视图控制器，根据类名
     *
     *  @param name  视图控制器类名
     *  @param param 视图控制器参数
     */
    @objc dynamic static func presentViewControllerWithName(name: String, param: NSDictionary?) {
        // 1:动态获取命名空间
        guard let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        let spaceClsName = spaceName + "." + name // VCName:表示试图控制器的类名
        var vcClass: AnyClass? = DFWFixRunTimeHandle.classFromString(spaceClsName)
        if vcClass == nil {
            vcClass = DFWFixRunTimeHandle.classFromString(name)
        }
        guard let typeClass = vcClass as? UIViewController.Type else {
            print("vcClass不能当做UIViewController")
            return
        }
        
        self.presentViewControllerWithClass(cls: typeClass, param: param)
    }

    /**
     *  present视图控制器，根据class
     *
     *  @param cls 视图控制器class
     */
    @objc dynamic static func presentViewControllerWithClass(cls: AnyClass) {
        self.presentViewControllerWithClass(cls: cls, param: nil)
    }

    /**
     *  present视图控制器，根据class
     *
     *  @param cls   视图控制器class
     *  @param param 视图控制器参数
     */
    @objc dynamic static func presentViewControllerWithClass(cls: AnyClass, param: NSDictionary?) {
        guard let viewController = self.viewControllerWithClass(cls: cls) else { return }
        self.presentViewController(viewController: viewController, param: param)
    }

    /**
     *  present视图控制器
     *
     *  @param viewController 视图控制器
     */
    @objc dynamic static func presentViewController(viewController: UIViewController) {
        self.presentViewController(viewController: viewController, param: nil)
    }

    /**
     *  present视图控制器
     *
     *  @param viewController 视图控制器
     *  @param param          视图控制器参数
     */
    @objc dynamic static func presentViewController(viewController: UIViewController, param: NSDictionary?) {
        self.presentViewController(viewController: viewController, param: param, animated: true)
    }

    /**
     *  present视图控制器,带动画
     *
     *  @param viewController 视图控制器
     *  @param param          视图控制器参数
     *  @param animated       是否开启动画
     */
    @objc dynamic static func presentViewController(viewController: UIViewController,
                                             param: NSDictionary?,
                                             animated: Bool)
    {
        guard let currentVC = findCurrentViewController() else {
            return
        }
        self.setupViewController(viewController: viewController, param: param)
        let navigationViewController = DFWBaseRootNavigatController(rootViewController: viewController)
        navigationViewController.isNavigationBarHidden = true
        navigationViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        currentVC.present(navigationViewController, animated: true, completion: nil)
    }
}
 
/// 工具方法
extension DFWManager {
    /**
     *  返回当前的导航视图控制器
     *
     *  @return 导航视图控制器
     */
    @objc dynamic static func currentNavigationController() -> UINavigationController? {
        let nvc = DFWControlTool().currentNavigationController()
        return nvc
    }
    
    /**
     *  返回当前导航控制器栈中指定的视图控制器
     *
     *  @param cls 视图控制器class
     *
     *  @return 指定的视图控制器
     */
    @objc dynamic static func controllerInNavigationStackWithClass(cls: AnyClass) -> UIViewController? {
        guard let currentNav = self.currentNavigationController() else { return nil }
        for viewController in currentNav.viewControllers {
            if viewController.isMember(of: cls) {
                return viewController
            }
        }
        return nil
    }

    /**
     *  返回当前导航控制器栈顶的视图控制器
     *
     *  @return 视图控制器
     */
    @objc dynamic static func topViewController() -> UIViewController? {
        let topViewController = self.currentNavigationController()
        return topViewController
    }

 
    /**
     返回当前视图控制器

     @return 当前视图控制器
     */
    @objc dynamic static func findCurrentViewController() -> UIViewController? {
        let vc = DFWControlTool().currentViewController()
        return vc
    }
    
    @objc dynamic static func rootViewController() -> UIViewController? {
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        return viewController
    }
}
