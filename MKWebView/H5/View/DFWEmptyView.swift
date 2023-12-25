//
//  DFWEmptyView.swift
//  DFMaxStore
//
//  Created by sunshine on 2022/12/20.
//

import UIKit

class DFWEmptyView: UIView {
    // 图标
    @objc lazy var imageView = UIImageView()
    // 标题
    @objc lazy var titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DFW_ColorFromHexColor(hexColor: "#FFFFFF")
        addSubviews()
      
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private dynamic func addSubviews() {
       
        // 图标
        self.addSubview(imageView)
        imageView.image = UIImage(named: "df_no_data")
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(260)
            make.height.equalTo(136)
        }
        
        // 标题
        self.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = DFW_ColorFromHexColor(hexColor: "#999999")
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
    }

}
