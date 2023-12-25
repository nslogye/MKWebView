//
//  DFWLog.swift
//  DFMaxStore
//
//  Created by sunshine on 2023/1/29.
//

import UIKit
/// Debug打印
/// - Parameter item: item
public func print(_ item: Any...) {
    #if DEBUG
        for _item in item {
            Swift.print(_item)
        }
    #endif
}

 
