//
//  DFWObjctExtensionFile.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/26.
//
import Foundation
import UIKit
/// 数字和字母
public let kNumber_Letters_Pattern = "^[A-Za-z0-9]+$"
 

/// 字符串判空
public func kStringIsEmpty(str: String?) -> Bool {
    var IsEmpty = false
    if str == nil || str?.isEmpty == true || (str?.count ?? 0) < 1 {
        IsEmpty = true
    }
    return IsEmpty
}

public extension String {
    /// 去掉首尾空格换行
    /// - Returns: 返回一个新字符串
    func trimLines() -> String {
        let trimString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimString
    }
    
    var isBlank: Bool {
        let trimmedStr = self.trimLines()
        return trimmedStr.isEmpty
    }
    
    // MARK: 汉字 -> 拼音
    func chineseToPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        var pinyin = stringRef as NSString
        
        if self.contains("长") {
            pinyin = pinyin.replacingCharacters(in: NSMakeRange(0, 5), with: "chang") as NSString
        }
        if self.contains("沈") {
            pinyin = pinyin.replacingCharacters(in: NSMakeRange(0, 4), with: "shen") as NSString
        }
        if self.contains("厦") {
            pinyin = pinyin.replacingCharacters(in: NSMakeRange(0, 3), with: "xia") as NSString
        }
        if self.contains("地") {
            pinyin = pinyin.replacingCharacters(in: NSMakeRange(0, 3), with: "di") as NSString
        }
        if self.contains("重") {
            pinyin = pinyin.replacingCharacters(in: NSMakeRange(0, 5), with: "chong") as NSString
        }
        
        return pinyin as String
    }
    
    // MARK: 判断是否含有中文
    func isIncludeChineseIn() -> Bool {
        for (_, value) in self.enumerated() {
            if value >= "\u{4E00}", value <= "\u{9FA5}" {
                return true
            }
        }
        
        return false
    }
    /// 正则匹配
    func isMatch(pattern: String) -> Bool {
        let letterRegex:NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return letterRegex.evaluate(with: self)
    }
     
    
    ///  根据字体、行数、行间距和指定的宽度constrainedWidth计算文本占据的size
    /// - Parameters:
    ///   - font: 字体样式
    ///   - numberOfLines: 最大行数
    ///   - lineSpacing: 行间距
    ///   - constrainedWidth: 文本指定宽度
    /// - Returns: 文本占据size
    ///
    func textSize(font: UIFont,
                  numberOfLines: Int,
                  lineSpacing: CGFloat,
                  constrainedWidth: CGFloat) -> CGSize
    {
        let str = self as NSString
        
        if self.count == 0 {
            return CGSize.zero
        }
        let oneLineHeight = font.lineHeight
        
        let textSize = str.boundingRect(with: CGSize(width: constrainedWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil).size
        var rows = textSize.height/oneLineHeight
        var realHeight: CGFloat = oneLineHeight
        
        if numberOfLines == 0 {
            if rows >= 1 {
                realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing
            }
            
        } else {
            if rows < CGFloat(numberOfLines) {
                rows = CGFloat(numberOfLines)
            }
            realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing
        }
        return CGSize(width: constrainedWidth, height: realHeight)
    }
    
    /// 根据字体、行数、指定的宽度constrainedWidth计算文本占据的size
    /// - Parameters:
    ///   - font: 字体样式
    ///   - numberOfLines: 最大行数
    ///   - constrainedWidth: 文本指定宽度
    /// - Returns: 文字size
    func textSize(font: UIFont,
                  numberOfLines: Int,
                  constrainedWidth: CGFloat) -> CGSize
    {
        let str = self as NSString
        
        if self.count == 0 {
            return CGSize.zero
        }
        let oneLineHeight = font.lineHeight
        
        let textSize = str.boundingRect(with: CGSize(width: constrainedWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil).size
        var rows = textSize.height/oneLineHeight
        var realHeight: CGFloat = oneLineHeight
        if numberOfLines == 0 {
            if rows >= 1 {
                realHeight = (rows * oneLineHeight) + (rows - 1)
            }
        } else {
            if rows > CGFloat(numberOfLines) {
                rows = CGFloat(numberOfLines)
            }
            realHeight = (rows * oneLineHeight) + (rows - 1)
        }
        //  返回真实的宽高
        return CGSize(width: constrainedWidth, height: realHeight)
    }
    
    /// 根据字体、行数、最大宽度limitWidth计算文本占据的size
    /// - Parameters:
    ///   - font: 字体
    ///   - limitWidth: 最大宽度
    /// - Returns: 文本长度
    func textSize(font: UIFont,
                  limitWidth: CGFloat) -> CGSize
    {
        let str = self as NSString
        var textSize = str.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 36), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil).size
        textSize.width = textSize.width > limitWidth ? limitWidth : textSize.width
        textSize.width = ceil(textSize.width)
        textSize.height = ceil(textSize.height)
        return textSize
    }

    func textSize(font: UIFont,
                  size: CGSize,
                  lineBreakMode: NSLineBreakMode) -> CGSize
    {
        let str = self as NSString
        var textSize = CGSize.zero
        
        if __CGSizeEqualToSize(size, CGSize.zero) {
            let attributes = [NSAttributedString.Key.font: font]
            textSize = str.size(withAttributes: attributes)
        } else {
            textSize = str.boundingRect(with: size,
                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                        attributes: [NSAttributedString.Key.font: font], context: nil).size
        }
        return textSize
    }

    /// 获取文本宽度
    func getWidth(font: UIFont) -> CGFloat {
        guard count > 0 else {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.size.width
    }
    
    /// 获取文本高度
    func getHeight(font: UIFont, limitWidth: CGFloat) -> CGFloat {
        guard count > 0, limitWidth > 0 else {
            return 0
        }
        let size = CGSize(width: limitWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return rect.size.height
    }

    /// 价格抹零 优先价格的抹零规则【如99.00 展示99；99.90 展示99.9】
    func removeLastAllZero() -> String {
        let price = self
        // 根据.进行数组拆分
        let priceList: [String] = price.components(separatedBy: ".")
        guard priceList.count > 1 else {
            return price
        }
        var last: String = priceList.last ?? ""
        while last.hasSuffix("0") {
            last.removeLast()
        }
        // 如果last为空，直接返回priceList数组第一个元素
        guard last.count > 0 else {
            return priceList.first ?? price
        }
        return (priceList.first ?? "") + "." + last
    }
    
    
    /// 获取小数点后面 小数
    func getPriceDecimal() -> String {
        let price = self
        // 根据.进行数组拆分
        let priceList: [String] = price.components(separatedBy: ".")
        guard priceList.count > 1 else {
            return ""
        }
        let decimal = priceList[1]
        return decimal
    }
    
    
}

public extension String {
    /// 获取指定长度的字符
    ///
    /// - Parameters:
    ///   - location: 起始位置
    ///   - length: 所需长度
    /// - Returns: 截取后的内容
    func subString(location: Int, length: Int) -> String {
        let fromIndex = self.index(startIndex, offsetBy: location)
        let toIndex = self.index(fromIndex, offsetBy: length)
        let subString = self[fromIndex..<toIndex]
        return String(subString)
    }
    
    /// 字符串根据每个字符分割成数组
    /// - Returns: description
    func stringToArray() -> [Character] {
        return self.enumerated().compactMap { $0.element }
    }

    // 获取url中的参数
    func getUrlParameters() -> [String: String]? {
        var params: [String: String] = [:]
            
        let array = self.components(separatedBy: "?")
        if array.count == 2 {
            let paramsStr = array[1]
            if paramsStr.count > 0 {
                let paramsArray = paramsStr.components(separatedBy: "&")
                for param in paramsArray {
                    let arr = param.components(separatedBy: "=")
                    if arr.count == 2 {
                        params[arr[0]] = arr[1]
                    }
                }
            }
        }
        return params
    }
}

public extension String {
    /// 指定分隔符和位数获取到新字符串
    /// - Parameters:
    ///   - stride:         隔位数
    ///   - separator:      分隔符
    /// - Returns:          result
    func separate(for stride: UInt, separator: String) -> String {
        var result = ""
        self.enumerated().forEach { index, char in
            if index % Int(stride) == 0, index > 0 {
                result += separator
            }
            result.append(char)
        }
        return result
    }
    
    /// 去除字符串空格
    /// - Returns: result
    func removeAllSapce() -> String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    /// 获取某个字符串在总字符串的位置
    func positionOf(sub: String,
                    backwards: Bool = false) -> Int?
    {
        var pos = -1
        if let range = range(of: sub, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        guard pos > -1 else {
            return nil
        }
        return pos
    }

    /// 获取字符串的范围
    
    func rangeOfString(sub: String) -> NSRange? {
        var pos = -1
        if let range = range(of: sub, options: .backwards) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        guard pos > -1 else {
            return nil
        }
        let range1 = NSRange(location: pos, length: sub.count)
        return range1
    }
    
    /// 替换指定范围内的字符串
    mutating func stringByReplacingCharactersInRange(index: Int,
                                                     length: Int,
                                                     replacText: String) -> String
    {
        guard index > 0, length > 0, index + length < self.count else {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: length), with: replacText)
        return self
    }
}


 
