//
//  DFWViewEventExtension.swift
//  DongFuWang
//
//  Created by 姜军辉 on 2022/8/11.
//

import Foundation
import UIKit


extension UIView {
    /// 移除所有子视图
    @objc dynamic public func removeAllChildView() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    /// 获取视图的控制器
    @objc dynamic public func getSuperController() -> UIViewController? {
        var next: UIView? = self
        while next != nil {
            let nextResponder = next?.next
            //  UINavigationController
            if let nvc = nextResponder as? UINavigationController {
                return nvc.viewControllers.last
            }
            
            // UIViewController
            if let vc: UIViewController = nextResponder as? UIViewController {
                return vc
            }
             
            next = next?.superview
        }
         
        return nil
    }
    
    /// 设置边框&圆角
    @objc dynamic public func setRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 设置边框的颜色和宽度
    @objc dynamic public func setBorder(_ color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 设置边框&圆角
    @objc dynamic public func setRadiusBorder(radius: CGFloat, color: UIColor, width: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 设置顶部边框
    public func addBorderTop(size: CGFloat, color: UIColor = DFW_ColorFromHexColor(hexColor: "#CCCCCC")) {
        // 如果已经有边框了,清除
        if layer.sublayers != nil {
            for item in layer.sublayers! {
                let name = item.name ?? ""
                if name == "top" {
                    item.removeFromSuperlayer()
                }
            }
        }
        layoutIfNeeded()
        addBorderUtility(x: 0, y: 0, width: bounds.size.width, height: size, color: color, name: "top")
    }

    /// 设置底部边框
    public func addBorderBottom(size: CGFloat, color: UIColor = DFW_ColorFromHexColor(hexColor: "#CCCCCC")) {
        // 如果已经有边框了,清除
        if layer.sublayers != nil {
            for item in layer.sublayers! {
                let name = item.name ?? ""
                if name == "bottom" {
                    item.removeFromSuperlayer()
                }
            }
        }
        layoutIfNeeded()
        addBorderUtility(x: 0, y: bounds.size.height - size, width: bounds.size.width, height: size, color: color, name: "bottom")
    }

    /// 设置左侧边框
    public func addBorderLeft(size: CGFloat, color: UIColor = DFW_ColorFromHexColor(hexColor: "#CCCCCC")) {
        // 如果已经有边框了,清除
        if layer.sublayers != nil {
            for item in layer.sublayers! {
                let name = item.name ?? ""
                if name == "left" {
                    item.removeFromSuperlayer()
                }
            }
        }
        layoutIfNeeded()
        addBorderUtility(x: 0, y: 0, width: size, height: bounds.size.height, color: color, name: "left")
    }

    /// 设置右侧边框
    public func addBorderRight(size: CGFloat, color: UIColor = DFW_ColorFromHexColor(hexColor: "#CCCCCC")) {
        // 如果已经有边框了,清除
        if layer.sublayers != nil {
            for item in layer.sublayers! {
                let name = item.name ?? ""
                if name == "right" {
                    item.removeFromSuperlayer()
                }
            }
        }
        layoutIfNeeded()
        addBorderUtility(x: bounds.size.width - size, y: 0, width: size, height: bounds.size.height, color: color, name: "right")
    }

    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor, name: String) {
        let border = CALayer()
        border.name = name
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    /// 是否屏幕可见 screenRect 可见rect，例如首页会有navigationBar和tabbar，视图可能在他们下面，不传默认window
    public func isDisplayedInScreen(screenRect: CGRect?) -> Bool {
        // 未添加到superview view 隐藏
        if self.superview == nil || self.isHidden {
            return false
        }
        let appDelegate = UIApplication.shared.delegate
        guard let window = appDelegate?.window else {
            return false
        }
        // 转换view对应window的Rect
        var rect = self.convert(self.bounds, to: window)
        // 如果可以滚动，清除偏移量
        if self.classForCoder.isSubclass(of: UIScrollView.classForCoder()) {
            if let scorll = self as? UIScrollView {
                rect.origin.x += scorll.contentOffset.x
                rect.origin.y += scorll.contentOffset.y
            }
        }
        // 若size为CGrectZero
        if CGRectIsEmpty(rect) || CGRectIsNull(rect) || CGSizeEqualToSize(rect.size, .zero) {
            return false
        }
        // 获取 该view与window 交叉的 Rect
        let windowBounds: CGRect = window?.bounds ?? .zero
        let _screenRect: CGRect = screenRect ?? windowBounds
        let intersectionRect = CGRectIntersection(rect, _screenRect)
        if CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect) {
            return false
        }
        
        return true
    }
    //将当前视图转为UIImage
    @objc dynamic public func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            guard bounds.size.height > 0 && bounds.size.width > 0 else {
                return nil
            }
            UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.width, height: bounds.height), false, 0)
            self.drawHierarchy(in: self.frame, afterScreenUpdates: true)  // 高清截图
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
            
        }
    }
}

// MARK: - 添加计算属性 --
struct DFWRunTimeViewKey {
    static let RunTimeViewName = UnsafeRawPointer(bitPattern: "RunTimeViewTagString".hashValue)
    static let RunTimeViewParam = UnsafeRawPointer(bitPattern: "RunTimeViewParam".hashValue)
    static let RunTimeViewArray = UnsafeRawPointer(bitPattern: "RunTimeViewArray".hashValue)
    static let RunTimeViewAny = UnsafeRawPointer(bitPattern: "RunTimeViewAny".hashValue)
}

extension UIView {
    public var tagString: String? {
        get {
            return objc_getAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewName!) as? String
        }
        set {
            objc_setAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewName!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var viewParam: [String: Any]? {
        get {
            return objc_getAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewParam!) as? Dictionary
        }
        set {
            objc_setAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewParam!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var viewArray: [Any]? {
        get {
            return objc_getAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewArray!) as? [Any]
        }
        set {
            objc_setAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewArray!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var viewAny: Any? {
        get {
            return objc_getAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewAny!)
        }
        set {
            objc_setAssociatedObject(self, DFWRunTimeViewKey.RunTimeViewAny!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

// MARK: - 点击方法 --
extension UIView {
    /// 点击事件
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, methods: String) {
        let action = Selector(methods)
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

class BlockTap: UITapGestureRecognizer {
    private var tapAction: ((UITapGestureRecognizer) -> Void)?

    override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init(
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((UITapGestureRecognizer) -> Void)?) {
        self.init()
        self.numberOfTapsRequired = tapCount
        #if os(iOS)
        self.numberOfTouchesRequired = fingerCount
        #endif

        self.tapAction = action
        self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }

    @objc open func didTap(_ tap: UITapGestureRecognizer) {
        self.tapAction?(tap)
    }
}
