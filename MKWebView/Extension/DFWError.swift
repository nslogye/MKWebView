//
//  DFWError.swift
//  DFMaxStore
//
//  Created by sunshine on 2022/12/6.
//

import UIKit

public struct DFWError: Error {
    public var reason: String = ""
    public var code: String = ""

    public init(code: String, reason: String) {
        self.code = code
        self.reason = reason
    }

    public init(reason: String) {
        self.reason = reason
    }
}
