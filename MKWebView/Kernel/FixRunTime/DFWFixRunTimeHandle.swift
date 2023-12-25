//
//  DFWFixRunTimeHandle.swift
//  DongFuWang
//
//  Created by qianduan-lianggq on 2022/2/18.
//

import UIKit

class DFWFixRunTimeHandle: NSObject {

    
    /// 通过字符得到类型
    @objc dynamic public class func classFromString(_ clsName: String) -> AnyClass? {
        let cls: AnyClass? = NSClassFromString(clsName)
        return cls
    }
    
    /// 通过字符得到方法
    @objc dynamic public class func selectorFromString(_ selectorName: String) -> Selector? {
        let sel = NSSelectorFromString(selectorName)
        return sel
    }
    
    @objc dynamic public class func classGetInstanceMethod(_ cls: AnyClass?,
                                                           _ name: Selector ) -> Method? {
        let method = class_getInstanceMethod(cls, name)
        return method
    }
    
    @objc dynamic public class func methodGetImplementation(_ m: Method) -> IMP {
        let imp = method_getImplementation(m)
        return imp
    }
    
    @objc dynamic public class func methodGetTypeEncoding(_ m: Method) -> UnsafePointer<CChar>? {
        let types = method_getTypeEncoding(m)
        return types
    }
    
    @objc dynamic public class func classAddMethod(_ cls: AnyClass?,
                                                   _ name: Selector,
                                                   _ imp: IMP,
                                                   _ types: UnsafePointer<CChar>?) -> Bool {
        let addResult = class_addMethod(cls, name, imp, types)
        return addResult
    }
    
    @objc dynamic public class func classReplaceMethod(_ cls: AnyClass?,
                                                       _ name: Selector,
                                                       _ imp: IMP,
                                                       _ types: UnsafePointer<CChar>?) -> IMP? {
        let imp = class_replaceMethod(cls, name, imp, types)
        return imp
    }
}

 
