//
//  LoadingHUD.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/3.
//

import Lottie
import UIKit
  
class LoadingHUD: UIView {
    /// 普通loading
    @discardableResult
    @objc dynamic class func show() -> MBProgressHUD? {
        let hub = LoadingHUD.showAnimationLoading(view: nil)
        return hub
    }

    /// 普通loading
    @discardableResult
    @objc dynamic class func showInView(view: UIView?) -> MBProgressHUD?{
        let hub = LoadingHUD.showAnimationLoading(view: view)
        return hub
    }
    
    /// 模态加载动画
    @discardableResult
    @objc dynamic class func showModeLoading(view: UIView?, isCenterWindow: Bool = true) -> MBProgressHUD? {
        guard let toView = LoadingHUD.getToView(view: view) else {
            assert(true, "找不到视图")
            return nil
        }
        LoadingHUD.hideHUDInView(view: toView)
        
        let loadingView = DFWAnimationView()
        loadingView.setup(name: "loadingReverse_lottie",
                          animationSize: CGSize(width: 36, height: 36),
                          boundsSize: CGSize(width: 120, height: 120))
        loadingView.bgView.backgroundColor = DFW_ColorFromHexAColor(hexColor: "#000000", alpha: 0.8)
        loadingView.bgView.setRadius(radius: 8.0)
        
        // 更新布局
        loadingView.loadingView?.snp.updateConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
        }
        loadingView.titleLabel.text = "loading_title"
        let hub = LoadingHUD.showAnimationHUD(toView: toView, animationView: loadingView)
        if isCenterWindow {
            // 计算偏移量 目的：让loading屏幕正中间
            calculatedOffset(view: toView, hub: hub)
        }
        
        return hub
    }
    
    /// 白屏加载 中间加载动画 带公司logo
    @discardableResult
    @objc dynamic class func showLogoLoading(view: UIView?, isCenterWindow: Bool = true) -> MBProgressHUD? {
        guard let toView = LoadingHUD.getToView(view: view) else {
            assert(true, "找不到视图")
            return nil
        }
        LoadingHUD.hideHUDInView(view: toView)
        
        let loadingView = DFWAnimationView()
        loadingView.setup(name: "loadingIP_lottie",
                          animationSize: CGSize(width: 100, height: 100),
                          boundsSize: CGSize(width: 100, height: 100))
        let hub = LoadingHUD.showAnimationHUD(toView: toView, animationView: loadingView)
        if isCenterWindow {
            // 计算偏移量 目的：让loading屏幕正中间
            calculatedOffset(view: toView, hub: hub)
        }
        
        return hub
    }
    
    /// 局部加载 中间加载动画
    @discardableResult
    @objc dynamic class func showAnimationLoading(view: UIView?, isCenterWindow: Bool = true) -> MBProgressHUD? {
        guard let toView = LoadingHUD.getToView(view: view) else {
            assert(true, "找不到视图")
            return nil
        }
        LoadingHUD.hideHUDInView(view: toView)
        
        let loadingView = DFWAnimationView()
        loadingView.setup(name: "loading_lottie",
                          animationSize: CGSize(width: 36, height: 36),
                          boundsSize: CGSize(width: 64, height: 64))
        
        loadingView.bgView.backgroundColor = DFW_ColorFromHexAColor(hexColor: "#ffffff", alpha: 0.8)
        loadingView.bgView.setRadius(radius: 4.0)
        let hub = LoadingHUD.showAnimationHUD(toView: toView, animationView: loadingView)
        if isCenterWindow {
            // 计算偏移量 目的：让loading屏幕正中间
            calculatedOffset(view: toView, hub: hub)
        }
        
        return hub
    }
    
    /// 普通提示文本
    @discardableResult
    @objc dynamic class func showWithStatus(status: String) -> MBProgressHUD? {
        let hub = self.showStatus(message: status, view: nil)
        return hub
    }
    
    /// 普通提示文本
    @discardableResult
    @objc dynamic class func showStatus(message: String, view: UIView?) -> MBProgressHUD? {
        let hub = self.showToast(message: message, view: view)
        return hub
    }
    
    /// 普通提示文本
    @discardableResult
    @objc dynamic class func showToastWithStatus(status: String) -> MBProgressHUD? {
        self.clearRecord()
        let hub = self.showToast(message: status, view: nil)
        return hub
    }
    
    /// 普通提示文本
    @discardableResult
    @objc dynamic class func showToast(message: String, view: UIView?) -> MBProgressHUD? {
        guard kStringIsEmpty(str: message) == false else {
            return nil
        }
        guard let toView = LoadingHUD.getToView(view: view) else {
            assert(true, "找不到视图")
            return nil
        }
        
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = message
        hud.detailsLabel.textColor = .white
        hud.detailsLabel.numberOfLines = 2
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud.minSize = CGSize(width: 120, height: 50)
        hud.bezelView.color = DFW_ColorFromHexAColor(hexColor: "#000000", alpha: 0.8)
        hud.bezelView.style = .solidColor
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.5)
        
        return hud
    }
    
    /// 成功
    @discardableResult
    @objc dynamic class func showSuccessWithStatus(status: String) -> MBProgressHUD? {
        let hub = self.showSuccess(message: status, view: nil)
        return hub
    }

    /// 成功
    @discardableResult
    @objc dynamic class func showSuccess(message: String, view: UIView?) -> MBProgressHUD? {
        self.clearRecord()
        let hub = self.showImageView(message: message, imageName: "df_loading_sucess", view: view)
        return hub
    }
    
    /// 失败
    @discardableResult
    @objc dynamic class func showErrorWithStatus(status: String) -> MBProgressHUD? {
        let hub = self.showError(message: status, view: nil)
        return hub
    }
    
    /// 失败
    @discardableResult
    @objc dynamic class func showError(message: String, view: UIView?) -> MBProgressHUD? {
        self.clearRecord()
        let hub = self.showImageView(message: message, imageName: "df_loading_fail", view: view)
        return hub
    }
    
    /// 隐藏loading
    @objc dynamic class func hidden() {
        dispatch_async_main_safe {
            self.clearRecord()
            self.hideHUDInView(view: nil)
        }
    }

    /// 隐藏loading
    @objc dynamic class func hideHUDInView(view: UIView?) {
        guard let toView = LoadingHUD.getToView(view: view) else {
            assert(true, "找不到视图")
            return
        }
         
        for item in toView.subviews where item.isKind(of: MBProgressHUD.classForCoder()) {
            MBProgressHUD.hide(for: toView, animated: true)
        }
    }
}

extension LoadingHUD {
    /// 弹出lottie动画
    @discardableResult
    @objc private dynamic class func showAnimationHUD(toView: UIView, animationView: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.customView = animationView
        hud.mode = .customView
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .clear
        hud.customView?.backgroundColor = .clear
        return hud
    }
    
    /// 弹出待icon的提示
    /// - Parameters:
    ///   - message: 文本
    ///   - imageName: 图片
    ///   - view: view
    @discardableResult
    @objc private dynamic class func showImageView(message: String,
                                                   imageName: String,
                                                   view: UIView?) -> MBProgressHUD?
    {
        guard kStringIsEmpty(str: message) == false else {
            return nil
        }
        // 查找视图
        guard let toView = LoadingHUD.getToView(view: view) else {
            assert(true, "找不到视图")
            return nil
        }
       
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(named: imageName))
        hud.detailsLabel.text = message
        hud.detailsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        hud.detailsLabel.numberOfLines = 2
        hud.detailsLabel.textColor = .white
        hud.minSize = CGSize(width: 120, height: 91)
        hud.bezelView.backgroundColor = DFW_ColorFromHexAColor(hexColor: "#000000", alpha: 0.8)
        hud.hide(animated: true, afterDelay: 2.0)
        hud.removeFromSuperViewOnHide = true
        return hud
    }
    
    /// 获取HUD 添加的ToView
    @objc private dynamic class func getToView(view: UIView?) -> UIView? {
        guard view == nil else {
            return view
        }
        let appDelegate = UIApplication.shared.delegate as? MKAppDelegate
        return appDelegate?.window
    }
    /// 获取window
    @objc private dynamic class func getToWindow() -> UIWindow? {
        let appDelegate = UIApplication.shared.delegate as? MKAppDelegate
        return appDelegate?.window
    }
    /// 判断界面是否出现了loading
    @objc dynamic class func existLoading(view: UIView?) -> MBProgressHUD? {
        guard let toView: UIView = LoadingHUD.getToView(view: view) else {
            return nil
        }
        for item in toView.subviews where item.isKind(of: MBProgressHUD.classForCoder()) {
            return item as? MBProgressHUD
        }
        return nil
    }
    
   
    /// 计算偏移量 目的：让loading屏幕正中间
    @objc dynamic class func calculatedOffset(view: UIView?, hub: MBProgressHUD) {
        let tag = view?.tag
        guard let toView = view,
              !toView.isKind(of: UIWindow.classForCoder()),
        tag == kDFWBaseRootViewTag else {
            return
        }
        // 是否显示NavigationBar
        let superViewController = toView.getSuperController() as? DFWBaseRootViewController
        let isHideNavigationBar: Bool = superViewController?.navigationBar.isHidden ?? false
        let y = isHideNavigationBar ? 0 : AppNavBarHeight
        
        // 是否显示tabbar
        let tabbarController = superViewController?.tabBarController
        let count = superViewController?.navigationController?.viewControllers.count ?? 0
        let isShowTabbar = count < 2 && tabbarController != nil
         
        if isShowTabbar {
            // 显示tabbar, 可以遮盖 NavigationBar
            hub.frame = CGRect(x: 0, y: 0, width: toView.dfw_width, height: toView.dfw_height)
            if toView.dfw_height != ApplicationHeight {
                let bottom = isShowTabbar ? AppTabBarHeight : 0
                hub.offset = CGPoint(x: 0, y:  bottom / 2)
            }
            
        } else {
            // 不显示tabbar, 不可以遮盖 NavigationBar
            hub.frame = CGRect(x: 0, y: y, width: toView.dfw_width, height: toView.dfw_height - y)
            hub.offset = CGPoint(x: 0, y: -y / 2)
        }
        
    }
}

extension LoadingHUD {
    static var recordControl = 0
    @objc dynamic class func recordController(controller: UIViewController) {
        objc_setAssociatedObject(self, &self.recordControl, controller, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc dynamic class func curController() -> UIViewController? {
        let viewController = objc_getAssociatedObject(self, &self.recordControl)
        return viewController as? UIViewController
    }

    @objc dynamic class func clearRecord() {
        if let currentController = DFWManager.findCurrentViewController(),
           let recordController = self.curController()
        {
            if type(of: recordController) == type(of: currentController) {
                self.hideHUDInView(view: recordController.view)
            }
        }
        objc_removeAssociatedObjects(self)
    }
}

class ToastView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 45)
    }

    @objc lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DFW_ColorFromHexColor(hexColor: "#ffffff")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class DFWAnimationView: UIView {
    @objc var bgView = UIView()
    /// lottie动画
    @objc var loadingView: AnimationView?
    /// 标题
    @objc var titleLabel = UILabel()
   
    @objc var boundsSize: CGSize = .zero
    override var intrinsicContentSize: CGSize {
        return self.boundsSize
    }
   
    @objc dynamic func setup(name: String,
                             animationSize: CGSize,
                             boundsSize: CGSize)
    {
        self.boundsSize = boundsSize
        // 背景
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
       
        // lottie 动画
        let animationView = AnimationView(name: name)
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
        self.bgView.addSubview(animationView)
       
        animationView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(animationSize.width)
            make.height.equalTo(animationSize.height)
        }
        self.loadingView = animationView
       
        /// 标题
        self.bgView.addSubview(self.titleLabel)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textColor = .white
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(animationView.snp.bottom)
        }
    }
}
