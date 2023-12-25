//
//  DFWBaseRootTabelView.swift
//  DongFuWang
//
//  Created by lianggq on 2020/10/24.
//

import UIKit


class DFWBaseRootTabelView: UITableView, UIGestureRecognizerDelegate{
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.estimatedRowHeight = 0
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
