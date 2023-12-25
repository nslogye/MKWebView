//
//  UIColorExtension.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2021/8/20.
//

import Foundation
import UIKit

// 颜色
public func DFW_ColorFromRGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

/// 16进制
public func DFW_ColorFrom16(h: Int) -> UIColor {
    return UIColor.colorFromBinary(h: h)
}

// 16进制加alpha
public func DFW_ColorAFrom16(h: Int, alpha: CGFloat) -> UIColor {
    return UIColor.colorFromBinary(h: h, alpha: alpha)
}

/// 16进制字符串转颜色
public func DFW_ColorFromHexColor(hexColor: String) -> UIColor {
    return UIColor.colorWithHexString(hexString: hexColor)
}

/// 16进制字符串转颜色 alpha
public func DFW_ColorFromHexAColor(hexColor: String, alpha: CGFloat) -> UIColor {
    return UIColor.colorWithHexString(hexString: hexColor, alpha: Float(alpha))
}

/// Color 扩展
public extension UIColor {
    /// rbg形式返回颜色
    /// - Parameters:
    ///   - r:              R
    ///   - g:              G
    ///   - b:              B
    ///   - alpha:          透明度
    /// - Returns:          UIColor
    @objc class func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0,
                       green: g/255.0,
                       blue: b/255.0,
                       alpha: alpha)
    }

    /// 通过16进制返回颜色
    /// - Parameter h:          16进制数字
    /// - Returns:              UIColor
    @objc class func colorFromBinary(h: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat((h>>16) & 0xFF)/255.0,
                       green: CGFloat((h>>8) & 0xFF)/255.0,
                       blue: CGFloat(h & 0xFF)/255.0,
                       alpha: alpha)
    }

    @objc class func colorWithHexString(hexString: String) -> UIColor {
        return self.colorWithHexString(hexString: hexString, alpha: 1.0)
    }

    @objc class func colorWithHexString(hexString: String, alpha: Float) -> UIColor {
        var colorString: String!
        if hexString.hasPrefix("#") {
            colorString = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            colorString = hexString
//            colorString = "000000"
        }
        if colorString.count != 6 {
            if colorString!.count == 3 {
                let colorArray = colorString!.stringToArray()
                let red = "\(colorArray[0])\(colorArray[0])"
                let green = "\(colorArray[1])\(colorArray[1])"
                let blue = "\(colorArray[2])\(colorArray[2])"
                colorString = red+green+blue
            } else {
                return UIColor.black
            }
        }
        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0

        Scanner(string: colorString.subString(location: 0, length: 2)).scanHexInt32(&red)
        Scanner(string: colorString.subString(location: 2, length: 2)).scanHexInt32(&green)
        Scanner(string: colorString.subString(location: 4, length: 2)).scanHexInt32(&blue)
        return UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(alpha * 1.0))
    }
}
