//
//  MKBaseRootModel.swift
//  MKWebView
//
//  Created by qianduan2731 on 2023/12/23.
//

import UIKit

class MKBaseRootModel: NSObject {
    public override init() {
        super.init()
    }
    
    
    public init(dictionary: Dictionary<String, Any>?){
        super.init()
        if let dic = dictionary {
            self.setParamsWithKeyData(keyValues: dic)
        }
    }
    
    
    @objc dynamic public func setParamsWithKeyData(keyValues: Dictionary<String, Any>){
        self.mj_setKeyValues(keyValues)
    }
    
    @objc dynamic open func dictionary() -> Dictionary<String, Any>?{
        let ignores = Array<String>.init()
        let dict = self.mj_keyValues(withIgnoredKeys: ignores)
        return dict as? Dictionary<String, Any>
    }
    
    @objc dynamic public class func modelsWithArrayData(arrays: [Dictionary<String, Any>]?) -> [MKBaseRootModel]?{
        let models = self.mj_objectArray(withKeyValuesArray: arrays)
        return models as? [MKBaseRootModel]
    }
    
    //设置数组
    override open func mj_didConvertToObject(withKeyValues keyValues: [AnyHashable : Any]!) {
        /*
        if( keyValues["tests"] != nil ){
            guard let testsData = keyValues["tests"] as? [Dictionary<String, Any>] else {
                return
            }
            self.tests = TestModel.modelsWithArrayData(arrays: testsData) as? [TestModel]
        }
        */
    }
}
