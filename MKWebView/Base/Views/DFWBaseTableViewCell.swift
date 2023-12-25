//
//  DFWBaseTableViewCell.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/4.
//

import UIKit


class DFWBaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    ///绑定model
    @objc dynamic func bindModel(model: MKBaseRootModel?) {
        
    }
    ///绑定viewModel
    @objc dynamic func bindViewModel(viewModel: MKBaseRootModel?) {
        
    }
    
}
