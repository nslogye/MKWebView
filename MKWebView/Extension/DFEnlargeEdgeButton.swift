//
//  DFWButtonExtension.swift
//  DFMaxStore
//
//  Created by sunshine on 2022/12/6.
/*
分类的侵入性比较大,如果给UIButton添加分类属性enlargeEdge,导致任何继承自UIButton的类都有这个功能.有可能人家压根就不想要这个功能,但是你本来就有这个功能
 子类化的话,你想要这个功能,你就用这个类,或者继承自这个类,能够做到精准控制
 */

import UIKit
// 扩大相应区域
class DFEnlargeEdgeButton: UIButton {
    @objc var enlargeEdge: UIEdgeInsets = .zero
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if alpha == 0 || isHidden == true || enlargeEdge == .zero {
            return super.hitTest(point, with: event)
        }
        let rect = CGRect(x: bounds.minX - enlargeEdge.left, y: bounds.minY - enlargeEdge.top, width: bounds.width + (enlargeEdge.left + enlargeEdge.right), height: bounds.height + (enlargeEdge.top + enlargeEdge.bottom))
        return rect.contains(point) ? self : nil
    }
}
 
