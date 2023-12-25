//
//  DFWBaseRootViewController.swift
//  DongFuWang
//
//  Created by lianggq on 2020/10/24.
//

import UIKit
import RxSwift
import SnapKit
typealias LeftNavigationItemEvent = (_ sender:UIButton) ->Void
typealias CloseNavigationItemEvent = (_ sender:UIButton) ->Void
typealias RightNavigationItemEvent = (_ sender:UIButton) ->Void
typealias ExtendNavigationItemEvent = (_ sender:UIButton) ->Void
#if DEBUG
/// 未被销毁的controller
var notDeallocationControllerList: [String] = Array()
#endif
public let kDFWBaseRootViewTag = 20201024


open class DFWBaseRootViewController: UIViewController,DFWTopBarViewDelegate,DFWBaseOpenURLProtocol {
    
    lazy var disposeBag = DisposeBag()
    /// 黑色导航栏
    @objc private var isDarkContentBackground: Bool = true
    
    // 错误页 【注意】还没有添加到父视图上面
    @objc lazy var errorView: DFWFailView = {
        let view = DFWFailView(frame: CGRect(x: 0, y: 0, width: ApplicationWidth, height: ApplicationHeight))
        view.isHidden = true
        return view
    }()
    
    @objc dynamic func pageParameters(params: Dictionary<String, Any>, backBlock: @escaping ((Dictionary<String, Any>) -> Void)) {
        
    }
    
    @objc var navigationMaxY: CGFloat = 0.0
    @objc var barColor:UIColor?
    @objc var titleColor:UIColor?
    @objc var navigationBarHidden = false
    @objc var hiddenBarLine : Bool = false {
        didSet{
            if hiddenBarLine {
                self.navigationBar.bottomLineView.removeFromSuperview()
            }
        }
    }
    @objc var itemTitle:String!
    
    @objc var barOpacity = false
    @objc var backImage:UIImage!
    @objc var navigationHidden = false
    @objc var leftEventBlock:LeftNavigationItemEvent?
    @objc var closeEventBlock:LeftNavigationItemEvent?
    @objc var rightEventBlock:RightNavigationItemEvent?
    @objc var extendEventBlock:RightNavigationItemEvent?
    
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if #available(iOS 13.0, *) {
            self.modalPresentationStyle = .fullScreen
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    required public init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = kDFWBaseRootViewTag
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.contentView)
        self.contentView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        self.setNavigationHidden(nagationHidden: false)
        
        if !navigationBarHidden {
            self.navigationBar.backgroundView.alpha = 1;
        }
        self.view.setNeedsUpdateConstraints()
        
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutNavigationBar()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc dynamic private func layoutNavigationBar()  {
        if let _ = navigationBar.superview  {
            return
        }
        if !self.navigationBarHidden {
            self.view.addSubview(self.navigationBar)
            self.navigationMaxY = 0
        }else{
            self.navigationMaxY = self.navigationBar.dfw_height
        }
        
    }
    
    
    @objc lazy var contentView: UIView = {
        let contentView = UIView.init()
        return contentView
    }()
    @objc lazy var navigationBar:DFWTopBarView = {
        var stytle:DFWTopBarStyle = DFWTopBarStyle.DFWTopBarStyleTitleWithLeftButton
//        if ((self.navigationController?.viewControllers.count)! > 1){
//            stytle = DFWTopBarStyle.DFWTopBarStyleTitleWithLeftButton
//        }
        let navView = DFWTopBarView.topBarViewWithStyle(topBarStyle: stytle, delegate:self)
        self.navigationMaxY = navView.frame.height
        if let _ = barColor {
            navView.backgroundView.backgroundColor = barColor;
        }else{
            navView.backgroundView.backgroundColor = DFW_ColorFromHexColor(hexColor: "#FFFFFF");
        }
        
        if let _ = titleColor {
            navView.titleLabel.textColor = titleColor;
        }
        return navView
    }()
    @objc dynamic func setBarColor(barColor:UIColor?, title:String?, titleColor:UIColor) {
        self.navigationBar.backgroundView.backgroundColor = barColor
        self.navigationBar.titleLabel.textColor = titleColor
        self.navigationBar.titleLabel.text = title
        self.barColor = barColor
        self.titleColor = titleColor
    }
    @objc dynamic func setHiddenBarLine(hiddenBarLine:Bool) {
        if hiddenBarLine {
            self.navigationBar.bottomLineView.removeFromSuperview()
        }
    }
    @objc dynamic func setItemTitle(itemTitle:String) {
        self.itemTitle = itemTitle
        self.navigationBar.titleLabel.text = self.itemTitle
    }
    @objc dynamic func setBarOpacity(barOpacity:Bool) {
        self.barOpacity = barOpacity
        if self.barOpacity {
            self.navigationBar.backgroundView.alpha = 1
        }else{
            self.navigationBar.backgroundView.alpha = 0
        }
    }
    
    @objc dynamic func setNavigationHidden(nagationHidden:Bool) {
        self.navigationHidden = nagationHidden
        if self.navigationHidden {
            self.navigationBar.isHidden = true
            self.navigationMaxY = 0
        }else{
            self.navigationBar.isHidden = false
            self.navigationMaxY = self.navigationBar.dfw_height
        }
        self.view.setNeedsUpdateConstraints()
    }
    
    override open func updateViewConstraints() {
        self.contentView.snp.remakeConstraints { (make) in
            if self.navigationHidden {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }else {
                make.top.equalTo(self.navigationMaxY)
            }
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        self.view.setNeedsLayout()
        super.updateViewConstraints()
    }
    
    @objc dynamic func setBackImage(backImage:UIImage) {
        self.backImage = backImage
        self.navigationBar.leftButtonImage = self.backImage
    }
    ///响应左侧按钮
    @objc dynamic func respondsToLeftEvent(block:@escaping LeftNavigationItemEvent) {
        self.leftEventBlock = block
    }
    ///响应左侧按钮
    @objc dynamic func respondsToCloseEvent(block:@escaping CloseNavigationItemEvent) {
        self.closeEventBlock = block
    }
    /// 响应右侧按钮
    @objc dynamic func respondsToRightEvent(block: @escaping RightNavigationItemEvent) {
        self.rightEventBlock = block
    }
    /// 响应右侧扩展按钮
    @objc dynamic func respondsToExtendEvent(block: @escaping ExtendNavigationItemEvent) {
        self.extendEventBlock = block
    }
    
    @objc dynamic func topBarLeftButtonPressed(button: UIButton) {
        if (self.leftEventBlock != nil) {
            self.leftEventBlock!(button)
        }
    }
    @objc dynamic func topBarCloseButtonPressed(button: UIButton) {
        if (self.closeEventBlock != nil) {
            self.closeEventBlock!(button)
        }
    }
    
    @objc dynamic func topBarRightButtonPressed(button: UIButton) {
        if (self.rightEventBlock != nil) {
            self.rightEventBlock!(button)
        }
    }
    
    @objc dynamic func topBarExtendButtonPressed(button: UIButton) {
        if (self.extendEventBlock != nil) {
            self.extendEventBlock!(button)
        }
    }

    /// 设置状态栏颜色
    @objc dynamic func setNavigationBarInterfaceStyle(isBlack: Bool) {
        isDarkContentBackground = isBlack
        setNeedsStatusBarAppearanceUpdate()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDarkContentBackground ? .default : .lightContent
    }
    
     
    deinit {
       
    }
}

