//
//  DFWJSONSerialization.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2021/12/21.
//

import Foundation


extension Dictionary {
    ///判读是否为空
    public var isNotEmpty: Bool { !isEmpty }
    /// json转字符串
    /// - Parameter
    ///   - encoding:       编码（default=utf8）
    ///   - options:        序列化选项
    /// - Returns:          解析后的字符串
    public func convertToString(encoding: String.Encoding = .utf8,
                                options: JSONSerialization.WritingOptions = []) -> String? {
        if let data = self.convertToData() {
            let jsonStr = String(data: data, encoding: encoding)
            return jsonStr
        }
        return nil
    }
    
    /// json转data
    /// - Parameter
    ///   - options:        序列化选项
    /// - Returns:          data
    public func convertToData(options: JSONSerialization.WritingOptions = []) -> Data? {
        if(JSONSerialization.isValidJSONObject(self)){
            if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
                return data
            }
        }
        return nil
    }
}


extension Array {
    ///判读是否为空
    public var isNotEmpty: Bool { !isEmpty }
    
    /// array转字符串
    /// - Parameter
    ///   - encoding:       编码（default=utf8）
    ///   - options:        序列化选项
    /// - Returns:          解析后的字符串
    public func convertToString(encoding: String.Encoding = .utf8,
                                options: JSONSerialization.WritingOptions = []) -> String? {
        if let data = self.convertToData(options: options) {
            let arrayStr = String(data: data, encoding: encoding)
            return arrayStr
        }
        return nil
    }
 
    /// array转data
    /// - Parameter
    ///   - options:        序列化选项
    /// - Returns:          data
    public func convertToData(options: JSONSerialization.WritingOptions = []) -> Data? {
        if(JSONSerialization.isValidJSONObject(self)){
            if let data = try? JSONSerialization.data(withJSONObject: self, options: options) {
                return data
            }
        }
        return nil
    }
}


extension Data {
    
    /// data转dictonary
    /// - Parameter
    ///   - options:        序列化选项
    /// - Returns:          dictonary
    public func convertToDictionary(options: JSONSerialization.ReadingOptions = []) -> Dictionary<String, Any>? {
        if let dict = try? JSONSerialization.jsonObject(with: self, options: options){
            if let result = dict as? Dictionary<String, Any> {
                return result
            }
        }
        return nil
    }
    
    /// data转array
    /// - Parameter
    ///   - options:        序列化选项
    /// - Returns:          array
    public func convertToArray(options: JSONSerialization.ReadingOptions = []) -> Array<Any>? {
        if let array = try? JSONSerialization.jsonObject(with: self, options: options){
            if let result = array as? Array<Any> {
                return result
            }
        }
        return nil
    }
    
}

extension String {
    ///判读是否为空
    public var isNotEmpty: Bool { !isEmpty }
    /// string转dictonary
    /// - Parameter
    ///   - options:        序列化选项
    /// - Returns:          dictonary
    public func convertToDictionary(options: JSONSerialization.ReadingOptions = []) -> Dictionary<String, Any>? {
        guard let transformStr = self.applyingTransform(StringTransform(rawValue: "Any-Hex/Java"), reverse: true) else {
            return nil
        }
        if let data = transformStr.data(using: .utf8) {
            if let dict = try? JSONSerialization.jsonObject(with: data, options: options){
                if let result = dict as? Dictionary<String, Any> {
                    return result
                }
            }
        }
        return nil
    }
    
    
    /// string转array
    /// - Parameter
    ///   - options:        序列化选项
    /// - Returns:          array
    public func convertToArray(options: JSONSerialization.ReadingOptions = []) -> Array<Any>? {
        guard let transformStr = self.applyingTransform(StringTransform(rawValue: "Any-Hex/Java"), reverse: true) else {
            return nil
        }
        if let data = transformStr.data(using: .utf8) {
            if let array = try? JSONSerialization.jsonObject(with: data, options: options){
                if let result = array as? Array<Any> {
                    return result
                }
            }
        }
        return nil
    }
}
extension Collection{
    /// 判断集合非空
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}
