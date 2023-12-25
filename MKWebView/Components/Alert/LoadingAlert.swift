//
//  LoadingAlert.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/3.
//

import UIKit

@objc enum TextDirection : Int {
    case TextDirectionLeft = 0
    case TextDirectionCenter = 1
    case TextDirectionRight = 2
}

let KSAlertWidth = ApplicationWidth - 2*40
let KSAlertBtnHeight = 44
typealias CommitAction = (_ index:Int) ->Void
class LoadingAlert: UIView {
    @objc var backgroundWindow : UIWindow?
    @objc var alertView : UIView?
    @objc var backgroundButton : UIButton?
    @objc var titleLabel : UILabel?
    @objc var messageTextView : UITextView?
    @objc var cancelButton : UIButton?
    @objc var commitButton : UIButton?
    @objc var druation : TimeInterval = 0.0
    
    
    init(title: String?, message:String?,direction:TextDirection,cancelTitle:String?,commitTitle:String?, backgorundHide:Bool,commitAction:@escaping CommitAction,druation:TimeInterval) {
        super.init(frame:UIScreen.main.bounds)
        self.backgroundColor = DFW_ColorAFrom16(h: 0x000000, alpha: 0.5)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundWindow = UIWindow.init(frame:UIScreen.main.bounds)
        self.backgroundWindow?.windowLevel = UIWindow.Level.alert
        self.alertView = UIView.init()
        self.alertView?.backgroundColor = UIColor.white
        self.alertView?.isUserInteractionEnabled = true
        self.druation = druation
        ///点击空白地方隐藏
        if backgorundHide {
            self.backgroundButton = UIButton.init(type: UIButton.ButtonType.custom)
            self.backgroundButton?.backgroundColor = UIColor.clear
            self.backgroundButton?.tag = 2
            self.backgroundButton?.handleControlEvent(event: UIControl.Event.touchUpInside, block: commitAction)
            self.backgroundButton?.addTarget(self, action: #selector(dismiss), for: UIControl.Event.touchUpInside)
            self.addSubview(self.backgroundButton!)
        }
        ///添加alertView
        self.addSubview(self.alertView!)
        /// 主标题
        if let stringCount = title?.count, stringCount > 0 {
            self.titleLabel = UILabel.init()
            self.titleLabel?.numberOfLines = 0
            self.titleLabel?.text = title
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            self.titleLabel?.textColor = DFW_ColorFromHexColor(hexColor: "#333333")
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.alertView?.addSubview(self.titleLabel!)
        }
        ///副标题
        if let stringCount = message?.count, stringCount > 0 {
            self.messageTextView = UITextView.init()
            self.messageTextView?.backgroundColor = .white
            self.messageTextView?.textContainer.lineFragmentPadding = 0.0
            self.messageTextView?.textContainerInset = UIEdgeInsets.zero
            self.messageTextView?.text = message
            self.messageTextView?.isEditable = false
            self.messageTextView?.textContainer.lineFragmentPadding = 0.0
            self.messageTextView?.textContainerInset = UIEdgeInsets.zero
            self.messageTextView?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            self.messageTextView?.textColor = DFW_ColorFromHexColor(hexColor: "#333333")
            self.messageTextView?.isScrollEnabled = false
            self.alertView?.addSubview(self.messageTextView!)
            if direction == .TextDirectionLeft {
                self.messageTextView?.textAlignment = .left
            }else if direction == .TextDirectionRight{
                self.messageTextView?.textAlignment = .right
            }else{
                self.messageTextView?.textAlignment = .center
            }
            
        }
        ///取消按钮
        if let stringCount = cancelTitle?.count, stringCount > 0 {
            self.cancelButton = UIButton.init(type: UIButton.ButtonType.custom)
            self.cancelButton?.backgroundColor = DFW_ColorFromHexColor(hexColor: "#ffffff")
            self.cancelButton?.tag = 0
            self.cancelButton?.setTitle(cancelTitle, for: UIControl.State.normal)
            self.cancelButton?.setTitleColor(DFW_ColorFromHexColor(hexColor: "#3FA6FF"), for: UIControl.State.normal)
            self.cancelButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            self.cancelButton?.handleControlEvent(event: UIControl.Event.touchUpInside, block: commitAction)
            self.cancelButton?.addTarget(self, action: #selector(dismiss), for: UIControl.Event.touchUpInside)
            self.alertView?.addSubview(self.cancelButton!)
        }
        ///确定
        if let stringCount = commitTitle?.count, stringCount > 0 {
            self.commitButton = UIButton.init(type: UIButton.ButtonType.custom)
            self.commitButton?.backgroundColor = DFW_ColorFromHexColor(hexColor: "#3FA6FF")
            self.commitButton?.tag = 1
            self.commitButton?.setTitle(commitTitle, for: UIControl.State.normal)
            self.commitButton?.setTitleColor(DFW_ColorFrom16(h: 0xffffff), for: UIControl.State.normal)
            self.commitButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            self.commitButton?.handleControlEvent(event: UIControl.Event.touchUpInside, block: commitAction)
            self.commitButton?.addTarget(self, action: #selector(dismiss), for: UIControl.Event.touchUpInside)
            self.alertView?.addSubview(self.commitButton!)
        }
        
        
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
//        self.alertView?.roundCorners(radius: 8.0)
        self.alertView?.setRadius(radius: 8.0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding:UIEdgeInsets = UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        let topMargin = padding.top
        let leftMargin = padding.left
        let rightMargin = padding.right
        var height : Float = 0.0
        if self.backgroundButton != nil {
            self.backgroundButton?.frame = self.bounds
        }
        if self.titleLabel != nil {
            let titleX = leftMargin
            let titleY = topMargin
            let titleW = KSAlertWidth - leftMargin - rightMargin
            let titleH = self.titleLabel?.frame.size.height
            self.titleLabel?.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH!)
            self.titleLabel?.sizeToFit()
            self.titleLabel?.center = CGPoint(x: KSAlertWidth / 2, y: self.titleLabel!.center.y)
            height = Float((self.titleLabel?.dfw_maxY)!) + 5.0
        }
        if self.messageTextView != nil {
            let messageSize = self.messageTextView?.text?.textSize(font:UIFont.systemFont(ofSize: 16, weight: .regular), numberOfLines: 0, constrainedWidth: KSAlertWidth - leftMargin - rightMargin)
            let messageX = leftMargin
            var titleMaxY : CGFloat = 0.0
            var messageY = 0.0
            let messageW = KSAlertWidth - leftMargin - rightMargin
            var messageH : CGFloat = 0.0
            if self.titleLabel == nil {
                if messageSize!.height < 24.0 {
                    messageH = 24.0
                    titleMaxY = 46.0
                    messageY = titleMaxY
                    self.messageTextView?.frame = CGRect(x: messageX, y: messageY, width: messageW, height: messageH)
                    self.messageTextView?.center = CGPoint(x: KSAlertWidth / 2, y: self.messageTextView!.center.y)
                    height = Float((self.messageTextView?.dfw_maxY)!) + 46.0
                }else{
                    titleMaxY = 20.0
                    messageY = titleMaxY
                    self.messageTextView?.frame = CGRect(x: messageX, y: messageY, width: messageW, height: messageSize!.height)
                    self.messageTextView?.center = CGPoint(x: KSAlertWidth / 2, y: self.messageTextView!.center.y)
                    height = Float((self.messageTextView?.dfw_maxY)!) + 20.0
                }
            }else{
                titleMaxY = self.titleLabel!.dfw_maxY+20.0
                messageY = titleMaxY
                if messageSize!.height < 60.0 {
                    messageH = 60.0
                }else if messageSize!.height > 218.0{
                    messageH = 218.0
                    self.messageTextView?.isScrollEnabled = true
                }else{
                    messageH = messageSize!.height
                }
                self.messageTextView?.frame = CGRect(x: messageX, y: CGFloat(messageY), width: messageW, height: messageH)
                self.messageTextView?.center = CGPoint(x: KSAlertWidth / 2, y: self.messageTextView!.center.y)
                height = Float((self.messageTextView?.dfw_maxY)!) + 20.0
            }
        }else{
            height = Float((self.titleLabel?.dfw_maxY)!) + 55.0
        }
        
        if self.cancelButton != nil && self.commitButton == nil {
            let cancelBtnX = 24
            let cancelBtnY = height
            let cancelBtnW = KSAlertWidth - 24*2
            let cancelBtnH = KSAlertBtnHeight
            self.cancelButton?.frame = CGRect(x: CGFloat(cancelBtnX), y: CGFloat(cancelBtnY), width: CGFloat(cancelBtnW), height: CGFloat(cancelBtnH))
            self.cancelButton?.layer.masksToBounds = true
            self.cancelButton?.layer.cornerRadius = 4.0
            self.cancelButton?.layer.borderWidth = 1.0
            self.cancelButton?.layer.borderColor = DFW_ColorFromHexColor(hexColor: "#3FA6FF").cgColor
        }
        if self.cancelButton == nil && self.commitButton != nil  {
            let commitBtnX = 24
            let commitBtnY = height
            let commitBtnW = KSAlertWidth - 24*2
            let commitBtnH = KSAlertBtnHeight
            self.commitButton?.frame = CGRect(x: CGFloat(commitBtnX), y: CGFloat(commitBtnY), width: CGFloat(commitBtnW), height: CGFloat(commitBtnH))
            self.commitButton?.layer.masksToBounds = true
            self.commitButton?.layer.cornerRadius = 4.0
            
            
        }
        if self.cancelButton != nil && self.commitButton != nil {
            let cancelBtnX = 24
            let cancelBtnY = height
            let cancelBtnW = KSAlertWidth/2 - 24 - 11
            let cancelBtnH = KSAlertBtnHeight
            self.cancelButton?.frame = CGRect(x: CGFloat(cancelBtnX), y: CGFloat(cancelBtnY), width: CGFloat(cancelBtnW), height: CGFloat(cancelBtnH))
            
            self.cancelButton?.layer.masksToBounds = true
            self.cancelButton?.layer.cornerRadius = 4.0
            self.cancelButton?.layer.borderWidth = 1
            self.cancelButton?.layer.borderColor = DFW_ColorFromHexColor(hexColor: "#3FA6FF").cgColor
            
            let commitBtnX = Int(cancelBtnW) + 22 + cancelBtnX
            let commitBtnY = cancelBtnY
            let commitBtnW = cancelBtnW
            let commitBtnH = KSAlertBtnHeight
            self.commitButton?.frame = CGRect(x: CGFloat(commitBtnX), y: CGFloat(commitBtnY), width: CGFloat(commitBtnW), height: CGFloat(commitBtnH))
            self.commitButton?.frame = CGRect(x: CGFloat(commitBtnX), y: CGFloat(commitBtnY), width: CGFloat(commitBtnW), height: CGFloat(commitBtnH))
            self.commitButton?.layer.masksToBounds = true
            self.commitButton?.layer.cornerRadius = 4.0
            
        }
        if self.cancelButton != nil || self.commitButton != nil {
            height += Float(KSAlertBtnHeight)
        }
        self.alertView?.frame = CGRect(x: 0, y: 0, width: KSAlertWidth, height: CGFloat(height) + 20)
        self.alertView?.center = self.center
        
    }
    @objc dynamic func setShowAnimation() {
        self.alertView?.layer.position = self.center
        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.5
//        let values = NSMutableArray.init(capacity: 0)
//        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
//        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
//        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
//        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
//        animation.values = (values as! [Any])
        self.alertView?.layer.add(animation, forKey: nil)
        self.alertView?.layer.position = self.center
        if self.druation != 0 {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { (ret) in
                self.dismiss()
            }
        }
    }
//    private func changeSpaceForLabel(label:UILabel, lineSpace:CGFloat, wordSpace:CGFloat) {
//        let labelText = label.text
//        let attributedString = NSMutableAttributedString.init(string: labelText!, attributes: [NSAttributedString.Key.kern:[wordSpace]])
//        let paragraphStyle = NSMutableParagraphStyle.init()
//        paragraphStyle.lineSpacing = lineSpace
//        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: labelText!.count))
//        label.attributedText = attributedString
////        label.sizeToFit()
//    }
    ///自动消失弹框类型
    /*@objc dynamic*/ class func showAutoHidden(title:String?, message:String?,direction:TextDirection, backgorundHide:Bool, druation:TimeInterval, commitAction:@escaping CommitAction) {
        let alert = LoadingAlert.init(title: title, message: message, direction:direction, cancelTitle: nil, commitTitle: nil, backgorundHide: backgorundHide, commitAction: commitAction, druation: druation)
        alert.show()
    }
    ///只有commit按钮类型
    /*@objc dynamic*/class func show(title:String?, message:String?,direction:TextDirection, commitButton:String?, backgorundHide:Bool, commitAction:@escaping CommitAction) {
        let alert = LoadingAlert.init(title: title, message: message,direction:direction, cancelTitle: nil, commitTitle: commitButton, backgorundHide: backgorundHide, commitAction: commitAction, druation: 0)
        alert.show()
    }
    ///包含cancel、commint按钮类型
    /*@objc dynamic*/ class func show(title:String?, message:String?, direction:TextDirection, cancelButton:String?, customButton:String?, backgorundHide:Bool, commitAction:@escaping CommitAction ) {
        let alert = LoadingAlert.init(title: title, message: message, direction:direction, cancelTitle: cancelButton, commitTitle: customButton, backgorundHide: backgorundHide, commitAction: commitAction, druation: 0)
        alert.show()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc dynamic func dismiss() {
        self.backgroundWindow?.resignKey()
        let window = UIApplication.shared.delegate!.window!
        window?.makeKeyAndVisible()
        window?.becomeKey()
        self.removeFromSuperview()
    }
    @objc dynamic func show() {
        self.backgroundWindow?.becomeKey()
        self.backgroundWindow?.makeKeyAndVisible()
        self.backgroundWindow?.addSubview(self)
        self.setShowAnimation()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension UIButton{
    private struct AssociatedKeys {
        static var overviewKey = 0
    }
    
    @objc dynamic func handleControlEvent(event:UIControl.Event, block:@escaping CommitAction) {
        objc_setAssociatedObject(self, &AssociatedKeys.overviewKey, block, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(callActionBlock(sender:)), for:event)
    }
    @objc dynamic func callActionBlock(sender:UIButton) {
        let block:CommitAction = objc_getAssociatedObject(self, &AssociatedKeys.overviewKey) as! CommitAction
        weak var weakSelf = self
        block(Int(weakSelf!.tag))
    }
    
}
