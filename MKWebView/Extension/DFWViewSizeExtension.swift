//
//  DFWViewSizeExtension.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2022/1/5.
//

import Foundation
import UIKit

public extension UIView {
    var dfw_center: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
    
    var dfw_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    var dfw_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    var dfw_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var dfw_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var dfw_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var dfw_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var dfw_maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            let x = newValue - self.frame.size.width
            self.dfw_x = x
        }
    }
    
    var dfw_maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            let y = newValue - self.frame.size.height
            self.dfw_y = y
        }
    }
    
    var dfw_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var dfw_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
}
