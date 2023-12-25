//
//  a.swift
//  DFMaxStore
//
//  Created by sunshine on 2022/9/15.
//

import Foundation
class DFWH5FloatViewData: NSObject {
    @objc static let share = DFWH5FloatViewData()
    @objc private var list: [String] = Array()
    private override init() {}
     
    /// 设置浮窗数据
    @objc dynamic func setData(_ text: String) {
        DFWH5FloatViewData.share.list.append(text)
    }
    
    /// 获取数据
    @objc dynamic func getData() -> [String] {
        return DFWH5FloatViewData.share.list
    }
    
}
