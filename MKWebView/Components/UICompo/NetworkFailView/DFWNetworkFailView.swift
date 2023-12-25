//
//  DFWNetworkFailView.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2020/12/21.
//

import UIKit
typealias RefreshAgainBlock = () ->Void

class DFWNetworkFailView: UIView {
    @objc private var refreshBlock : RefreshAgainBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DFW_ColorFromHexColor(hexColor: "#FFFFFF")
        self.addSubviews()
    }
    @objc dynamic func addSubviews() {
        self.addSubview(self.iconImgView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.refeshButton)
        self.iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(237)
            make.width.equalTo(280)
            make.height.equalTo(90)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.iconImgView.snp.bottom).offset(3)
            make.height.equalTo(26)
        }
        self.refeshButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.iconImgView.snp.bottom).offset(51)
            make.width.equalTo(145)
            make.height.equalTo(44)
        }
        
     }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc lazy var iconImgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.image = UIImage.init(named: "dfw_network_fail_iocn")
        return imgView
    }()
    @objc lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = DFW_ColorFromHexColor(hexColor: "#999999")
        label.textAlignment = .center
        label.text = "message.fail_title"
        return label
    }()
    @objc lazy var refeshButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = DFW_ColorFromHexColor(hexColor: "#2C7DFF")
        button.setTitle("button.fail_refesh", for: .normal)
        button.setTitleColor(DFW_ColorFromHexColor(hexColor: "#FFFFFF"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(buttonWithClick), for: .touchUpInside)
        return button
    }()
    @objc dynamic func buttonWithClick() {
        if self.refreshBlock != nil {
            self.refreshBlock!()
        }
    }
    
    /// 刷新
    /// - Parameter block: block description
    @objc dynamic public func refreshAgain(block:@escaping RefreshAgainBlock) {
        self.refreshBlock = block
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
