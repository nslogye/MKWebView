//
//  DFWBaseRootView.swift
//  DongFuWang
//
//  Created by lianggq on 2020/10/24.
//

import UIKit

open class DFWBaseRootView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///绑定ViewModel
    @objc dynamic func bindWithViewModel(viewModel:Any) {
        
    }
    ///绑定model
    @objc dynamic func bindModel(model: MKBaseRootModel?) {
        
    }
}
