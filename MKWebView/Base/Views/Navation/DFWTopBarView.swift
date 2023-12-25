//
//  DFWTopBarView.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/10/26.
//

import UIKit

let kTopBarHeight = AppContentBarHeight
let kTopBarRect = CGRect(x:0, y:0, width:CGFloat(ApplicationWidth), height:CGFloat(kTopBarHeight + AppStatusBarHeight))
let kTopBarLineRect = CGRect(x:0, y:CGFloat(44 + AppStatusBarHeight), width:CGFloat(ApplicationWidth) , height:0.5)
let kTopBarLeftButtonRect = CGRect(x:16, y:CGFloat(AppStatusBarHeight), width:65, height:kTopBarHeight)
let kTopBarCloseButtonRect = CGRect(x:50, y:CGFloat(AppStatusBarHeight), width:65, height:kTopBarHeight)

func kTopBarTitleLabelRect(scale:CFloat) ->CGRect{
    return CGRect(x:(ApplicationWidth - 180*CGFloat(scale)) / 2, y:CGFloat(AppStatusBarHeight), width:CGFloat(180*scale), height:kTopBarHeight)
}
func kTopBarWithSubtitleTitleLabelRect(scale:CGFloat) ->CGRect{
    return CGRect(x:(ApplicationWidth - 120*CGFloat(scale))/2, y: CGFloat(AppStatusBarHeight), width: CGFloat(120*scale), height: 30)
}
func kTopBarSubTitleLabelRect(scale:CGFloat) ->CGRect{
    return CGRect(x: (ApplicationWidth - 120*CGFloat(scale))/2, y: kTopBarHeight, width: 120*CGFloat(scale), height: 20)
}

let kTopBarRightButtonRect = CGRect(x: ApplicationWidth - 80, y: AppStatusBarHeight, width: 65, height: kTopBarHeight)
let kTopBarRightButtonWithExtendRect = CGRect(x: ApplicationWidth - 64, y: AppStatusBarHeight, width: 50, height: kTopBarHeight)
let kTopBarExtendButtonRect = CGRect(x: ApplicationWidth - 104, y: AppStatusBarHeight, width: 50, height: kTopBarHeight)

let kTopBarLeftViewRect = CGRect(x:0, y:0, width:CGFloat(ApplicationWidth/3), height:CGFloat(kTopBarHeight + AppStatusBarHeight))
let kTopBarCenterViewRect = CGRect(x:0, y:CGFloat(ApplicationWidth/3), width:CGFloat(ApplicationWidth/3), height:CGFloat(kTopBarHeight + AppStatusBarHeight))
let kTopBarRightViewRect = CGRect(x:0, y:CGFloat(ApplicationWidth/3*2), width:CGFloat(ApplicationWidth/3), height:CGFloat(kTopBarHeight + AppStatusBarHeight))
let kTopBarButtonTitleFont = UIFont.systemFont(ofSize: 14)


@objc enum DFWTopBarStyle: Int {
    case DFWTopBarStyleDefault //默认无标题
    case DFWTopBarStyleTitle //只有标题
    case DFWTopBarStyleLeftButton //只有左侧按钮 无标题
    case DFWTopBarStyleRightButton //只有右侧按钮 无标题
    case DFWTopBarStyleTitleWithLeftButton //左侧按钮 有标题
    case DFWTopBarStyleTitleWithRightButton //右侧按钮 有标题
    case DFWTopBarStyleTitleWithRightButtonAndExtendButton //右右按钮 标题
    case DFWTopBarStyleTitleWithLeftButtonAndRightButton //左右按钮 标题
    case DFWTopBarStyleTitleWithLeftButtonAndRightButtonAndExtendButton // 左右右按钮 标题
    case DFWTopBarStyleTitleWithLeftButtonAndSubTitle //左按钮 主副标题
    case DFWTopBarStyleTitleWithLeftButtonAndSubTitleAndRightButton //左右按钮 主副标题
    case DFWTopBarStyleTitleWithLeftButtonAndCloseButtonAndRightButton //左左右按钮 标题
    case DFWTopBarStyleCustom //导航栏自定义view
    case DFWTopBarStyleNone //无导航栏
}

/// 导航栏右侧&右侧按钮点击方法
@objc protocol DFWTopBarViewDelegate:NSObjectProtocol{
    func topBarLeftButtonPressed(button:UIButton)
    func topBarCloseButtonPressed(button:UIButton)
    func topBarRightButtonPressed(button:UIButton)
    func topBarExtendButtonPressed(button:UIButton)
}
class DFWTopBarView: UIView {
    @objc weak var topDelegate : DFWTopBarViewDelegate?
    /*@objc*/ public var  topBarStyle: DFWTopBarStyle?
    @objc var titleText : String?
    @objc var subTitleText : String?
    @objc var leftButtonTitle : String?
    @objc var closeButtonTitle : String?
    @objc var rightButtonTitle : String?
    @objc var extendButtonTitle : String?
    @objc var leftButtonImage : UIImage?
    @objc var closeButtonImage : UIImage?
    @objc var rightButtonImage : UIImage?
    @objc var extendButtonImage : UIImage?
    @objc var navigationBarHidden = false
    
    init(frame:CGRect, topBarStyle:DFWTopBarStyle, delegate:DFWTopBarViewDelegate){
        super.init(frame: frame)
        self.setTopBarStyle(topBarStyle: topBarStyle)
        topDelegate = delegate
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    @objc dynamic public static func topBarViewWithStyle(topBarStyle:DFWTopBarStyle,delegate:DFWTopBarViewDelegate) ->DFWTopBarView {
        let topBarView = DFWTopBarView.init(frame: kTopBarRect, topBarStyle: topBarStyle, delegate: delegate)
        
        return topBarView
    }
    @objc dynamic private func setupTopBarView(topBarStyle:DFWTopBarStyle){
        for item:UIView in self.subviews {
            item.removeFromSuperview()
        }
        
        switch topBarStyle{
        case .DFWTopBarStyleDefault:
            self.addSubview(self.backgroundView)
            break
        case .DFWTopBarStyleTitle:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            break
        case .DFWTopBarStyleLeftButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.leftButton)
            break
        case .DFWTopBarStyleRightButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.rightButton)
            break
        case .DFWTopBarStyleTitleWithLeftButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.leftButton)
            break
        case .DFWTopBarStyleTitleWithRightButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.rightButton)
            break
        case .DFWTopBarStyleTitleWithRightButtonAndExtendButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.rightButton)
            self.addSubview(self.extendButton)
            break
        case .DFWTopBarStyleTitleWithLeftButtonAndRightButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.leftButton)
            self.addSubview(self.rightButton)
            break
        case .DFWTopBarStyleTitleWithLeftButtonAndRightButtonAndExtendButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.leftButton)
            self.addSubview(self.extendButton)
            self.addSubview(self.rightButton)
            break
        case .DFWTopBarStyleCustom:
            self.addSubview(self.leftView)
            self.addSubview(self.centerView)
            self.addSubview(self.rightView)
            break
        case .DFWTopBarStyleNone:
            self.frame = CGRect.zero;
            break
        case .DFWTopBarStyleTitleWithLeftButtonAndSubTitle:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.subTitleLabel)
            self.addSubview(self.leftButton)
            break
        case .DFWTopBarStyleTitleWithLeftButtonAndSubTitleAndRightButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.leftButton)
            self.addSubview(self.rightButton)
            self.addSubview(self.subTitleLabel)
            break
        case .DFWTopBarStyleTitleWithLeftButtonAndCloseButtonAndRightButton:
            self.addSubview(self.backgroundView)
            self.addSubview(self.titleLabel)
            self.addSubview(self.leftButton)
            self.addSubview(self.closeButton)
            self.addSubview(self.rightButton)
            break
       default: break
        }
        self.backgroundView.addSubview(self.bottomLineView)
    }

    ///dealloc方法
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 懒加载
    @objc lazy var backgroundView : UIView = {
        let view = UIView()
        view.frame = kTopBarRect
        view.backgroundColor = DFW_ColorFrom16(h: 0xf8f8f8)
        return view
    }()
    
    @objc lazy var bottomLineView: UIView = {
        let view = UIView.init(frame: kTopBarLineRect)
        view.backgroundColor = DFW_ColorAFrom16(h: 0x000000, alpha: 0.1)
        return view
    }()
    ///主标题
     @objc lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.frame  = kTopBarTitleLabelRect(scale:1)
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.textColor = DFW_ColorFrom16(h: 0x181818)
        label.textAlignment = NSTextAlignment.center
        if case .DFWTopBarStyleTitleWithLeftButtonAndSubTitle? = topBarStyle {
            label.frame = kTopBarWithSubtitleTitleLabelRect(scale: 1);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                label.frame = kTopBarWithSubtitleTitleLabelRect(scale: 1.8);
            }
        }else if case .DFWTopBarStyleTitleWithLeftButtonAndSubTitleAndRightButton? = topBarStyle{
            label.frame = kTopBarWithSubtitleTitleLabelRect(scale: 1);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                label.frame = kTopBarWithSubtitleTitleLabelRect(scale: 1.8);
            }
        }else{
            label.frame = kTopBarTitleLabelRect(scale: 1);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                label.frame = kTopBarTitleLabelRect(scale:1.8);
            }
        }
        label.center = CGPoint(x: self.center.x, y: self.leftButton.center.y);
        return label
    }()
    ///副标题
    @objc lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.frame  = kTopBarSubTitleLabelRect(scale:1)
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = DFW_ColorFrom16(h: 0x999999)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            label.frame = kTopBarSubTitleLabelRect(scale:1.8);
        }
        return label
    }()
    ///左侧第一个按钮
    @objc lazy var leftButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame  = kTopBarLeftButtonRect
        button.titleLabel?.font = kTopBarButtonTitleFont
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.normal)
        button.setTitleColor(DFW_ColorFrom16(h: 0x999999), for: UIControl.State.disabled)
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.highlighted)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        button.addTarget(self, action: #selector(leftButtonPressed(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    ///左侧第二个按钮
    @objc lazy var closeButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame  = kTopBarCloseButtonRect
        button.titleLabel?.font = kTopBarButtonTitleFont
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.normal)
        button.setTitleColor(DFW_ColorFrom16(h: 0x999999), for: UIControl.State.disabled)
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.highlighted)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        button.addTarget(self, action: #selector(closeButtonPressed(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    ///右侧第一个按钮
    @objc lazy var rightButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame  = kTopBarRightButtonRect
        button.titleLabel?.font = kTopBarButtonTitleFont
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.normal)
        button.setTitleColor(DFW_ColorFrom16(h: 0x999999), for: UIControl.State.disabled)
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.highlighted)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right;
        button.setImage(UIImage(named: ""), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(rightButtonPressed(button:)), for: UIControl.Event.touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 4);
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4);
        var center:CGPoint = button.center
        center.y = self.titleLabel.center.y
        button.center = center
        if topBarStyle == .DFWTopBarStyleTitleWithLeftButtonAndRightButtonAndExtendButton{
            button.frame = kTopBarRightButtonWithExtendRect;
        }else if topBarStyle == .DFWTopBarStyleTitleWithRightButtonAndExtendButton{
            button.frame = kTopBarRightButtonWithExtendRect;
        }else{
            button.frame = kTopBarRightButtonRect;
        }
        return button
    }()
    ///右侧第二个按钮
    @objc lazy var extendButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame  = kTopBarExtendButtonRect
        button.titleLabel?.font = kTopBarButtonTitleFont
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.normal)
        button.setTitleColor(DFW_ColorFrom16(h: 0x999999), for: UIControl.State.disabled)
        button.setTitleColor(DFW_ColorFrom16(h: 0x222222), for: UIControl.State.highlighted)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right;
        button.addTarget(self, action: #selector(extendButtonPressed(button:)), for: UIControl.Event.touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0);
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        return button
    }()
    
    @objc lazy var leftView: UIView = {
        let view = UIView.init(frame: kTopBarLeftViewRect)
        view.backgroundColor = UIColor.white
        return view
    }()
    @objc lazy var centerView: UIView = {
        let view = UIView.init(frame: kTopBarCenterViewRect)
        view.backgroundColor = UIColor.white
        return view
    }()
    @objc lazy var rightView: UIView = {
        let view = UIView.init(frame: kTopBarRightViewRect)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc dynamic func setTitleText(titleText:String) {
        if (self.titleText == titleText) {
            
        }
        else {
            self.titleText = titleText
            self.titleLabel.text = self.titleText
        }
    }
    @objc dynamic func setSubTitleText(subTitleText:String) {
        if (self.subTitleText == subTitleText) {
            
        }
        else {
            self.subTitleText = subTitleText
            self.subTitleLabel.text = self.subTitleText;
        }
    }
    ///左侧按钮事件
    @objc dynamic func setLeftButtonTitle(leftButtonTitle:String) {
        if (self.leftButtonTitle == leftButtonTitle) {
            
        }else {
            self.leftButtonTitle = leftButtonTitle
            self.leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            self.leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            self.leftButton.setTitle(self.leftButtonTitle, for: UIControl.State.normal)
        }
    }
    @objc dynamic func setLeftButtonImage(leftButtonImage:UIImage?) {
        self.leftButtonImage = leftButtonImage
        self.leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        self.leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.leftButton.setImage(self.leftButtonImage, for: UIControl.State.normal)
    }
    @objc dynamic func setLeftButtonTitleAndImage(title:String, image:UIImage?) {
        if (self.leftButtonTitle == title) {
            
        }else {
            self.leftButtonTitle = title
            self.leftButtonImage = image
            let font:UIFont =  UIFont.systemFont(ofSize: 16, weight: .semibold)
            let attributes = [NSAttributedString.Key.font:font]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let imgWidth = (image == nil) ? 0.0 : image!.size.width
            let spaceWidth = 4
            let rect:CGRect = title.boundingRect(with: CGSize.init(width: 320.0, height: 999.9),options: option,attributes: (attributes as [NSAttributedString.Key : Any]),context:nil)
            self.leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: rect.width, bottom: 0, right: -rect.width)
            self.leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imgWidth + CGFloat(spaceWidth)), bottom: 0, right:imgWidth + CGFloat(spaceWidth))
            self.leftButton.setTitle(self.leftButtonTitle, for: UIControl.State.normal)
            self.leftButton.setImage(self.leftButtonImage, for: UIControl.State.normal)
            self.leftButton.setTitleColor(DFW_ColorFromHexColor(hexColor: "#FFFFFF"), for: .normal)
            if rect.width < 80 {
                self.leftButton.frame = CGRect.init(x: 16, y: CGFloat(AppStatusBarHeight), width: rect.width + imgWidth + CGFloat(spaceWidth), height: 44)
            }else{
                self.leftButton.frame = CGRect.init(x: 16, y: CGFloat(AppStatusBarHeight), width: 80 + imgWidth + CGFloat(spaceWidth), height: 44)
            }
            
        }
    }
    ///右侧按钮事件
    @objc dynamic func setRightButtonTitle(rightButtonTitle:String) {
        if (self.rightButtonTitle == rightButtonTitle) {
            
        }
        else {
            self.rightButtonTitle = rightButtonTitle
            self.rightButton.setTitle(self.rightButtonTitle, for: UIControl.State.normal)
        }
    }
    @objc dynamic func setRightButtonImage(rightButtonImage:UIImage?) {
        self.rightButtonImage = rightButtonImage
        self.rightButton.setImage(self.rightButtonImage, for: UIControl.State.normal)
    }
    @objc dynamic func setRightButtonImage(rightButtonImage:UIImage?, highlightedImage:UIImage?) {
        self.rightButtonImage = rightButtonImage
        self.rightButton.setImage(highlightedImage, for: UIControl.State.highlighted)
    }
    @objc dynamic func setRightButtonFromShareButton(shareButton:UIButton) {
        self.rightButton = shareButton
        self.rightButton.frame = shareButton.frame
        self.rightButton.addTarget(self, action: #selector(rightButtonPressed(button:)), for: UIControl.Event.touchUpInside)
        self.addSubview(self.rightButton)
    }
    ///扩展按钮事件
    @objc dynamic func setExtendButtonImage(extendButtonImage:UIImage?,highlightedImage:UIImage?) {
        self.extendButtonImage = extendButtonImage
        self.extendButton.setImage(highlightedImage, for: UIControl.State.highlighted)
    }
    @objc dynamic func setExtendButtonImage(extendButtonImage:UIImage?) {
        self.extendButtonImage = extendButtonImage
        self.extendButton.setImage(self.extendButtonImage, for: UIControl.State.normal)
    }
    @objc dynamic func setExtendButtonTitle(extendButtonTitle:String) {
        if (self.extendButtonTitle == extendButtonTitle) {
            return;
        }
        self.extendButtonTitle = extendButtonTitle
        self.extendButton.setTitle(self.extendButtonTitle, for: UIControl.State.normal)
    }
    @objc dynamic func setCloseButtonImage(closeButtonImage:UIImage?) {
        self.closeButtonImage = closeButtonImage
        self.closeButton.setImage(self.closeButtonImage, for: UIControl.State.normal)
    }
    @objc dynamic func setCloseButtonTitle(closeButtonTitle:String) {
        if (self.closeButtonTitle == closeButtonTitle) {
            return;
        }
        self.closeButtonTitle = closeButtonTitle
        self.closeButton.setTitle(self.closeButtonTitle, for: UIControl.State.normal)
    }
    @objc dynamic func setExtendButtonFromShareButton(shareButton:UIButton) {
        self.extendButton = shareButton
        self.extendButton.frame = shareButton.frame
        self.extendButton.addTarget(self, action: #selector(extendButtonPressed(button:)), for: UIControl.Event.touchUpInside)
        self.addSubview(self.extendButton)
    }
    ///设置导航栏类型
    @objc dynamic func setTopBarStyle(topBarStyle:DFWTopBarStyle) {
        if (self.topBarStyle == topBarStyle) {
            
        }else{
            self.topBarStyle = topBarStyle
            self.setupTopBarView(topBarStyle: self.topBarStyle!)
        }
    }
    @objc dynamic func setLeftButtonToBackButton() {
        self.leftButtonImage = UIImage(named: "base_topbar_icon_nav_back")
        self.leftButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        self.leftButton.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
    }
    
    ///
    @objc dynamic func leftButtonPressed(button:UIButton) {
        
        self.topDelegate?.topBarLeftButtonPressed(button: button)
    }
    @objc dynamic func closeButtonPressed(button:UIButton) {
        self.topDelegate?.topBarCloseButtonPressed(button: button)
    }
    @objc dynamic func rightButtonPressed(button:UIButton) {
        self.topDelegate?.topBarRightButtonPressed(button: button)
        
    }
    @objc dynamic func extendButtonPressed(button:UIButton) {
        self.topDelegate?.topBarExtendButtonPressed(button: button)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension DFWTopBarView{
    
}

