//
//  DFWBaseTableHeaderFooterView.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/4.
//

import UIKit

class DFWBaseTableHeaderFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///获取高度
    @objc dynamic class func heightWithData(data:AnyObject) -> CGFloat {
        return 0.1
    }
    ///绑定model
    @objc dynamic func bindModel(model: MKBaseRootModel?) {
        
    }
    ///绑定viewModel
    @objc dynamic func bindViewModel(viewModel: MKBaseRootModel?) {
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
