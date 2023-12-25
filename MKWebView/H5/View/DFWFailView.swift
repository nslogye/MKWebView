//
//  DFWNetErrorEmptyView.swift
//  DFMaxStore
//
//  Created by sunshine on 2022/12/6.


import UIKit

class DFWFailView: UIView {
    @objc public dynamic var refreshBlock: RefreshAgainBlock?
    // 图标
    @objc lazy var imageView = UIImageView()
    // 标题
    @objc lazy var titleLabel = UILabel()
    // 刷新按钮
    @objc lazy var refreshButton = UIButton()
    /// 是否已经刷新标题 防止一直闪烁
    @objc lazy var isRefreshTitle = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DFW_ColorFromHexColor(hexColor: "#FFFFFF")
        addSubviews()
        
        // 监听网络变化
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidChanged(notifi:)), name: Notification.Name.dfwNetworkDidChanged, object: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private dynamic func addSubviews() {
      
        // 刷新按钮
        refreshButton.backgroundColor = DFW_ColorFromHexColor(hexColor: "#3FA7FF")
        refreshButton.setTitle("net_error_refresh_title", for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        refreshButton.setTitleColor(DFW_ColorFromHexColor(hexColor: "#FFFFFF"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshEvent), for: .touchUpInside)
        self.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(44)
        }
        refreshButton.setRadius(radius: 4)
        
        // 图标
        self.addSubview(imageView)
        imageView.image = UIImage(named: "df_network_fail")
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(refreshButton.snp.top).offset(-50)
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
        
        let isConnection = DFWAppNetworkMonitor.isConnection()
        let title = isConnection ? "net_error_refresh_tip" : "title.network.fail"
        titleLabel.text = title
    
    }
    
    /// 刷新
    @objc private dynamic func refreshEvent() {
        if refreshBlock != nil {
            refreshBlock!()
        }
    }
    
    /// 刷新
    /// - Parameter block: block description
    @objc public dynamic func refreshAgain(block: @escaping RefreshAgainBlock) {
        refreshBlock = block
    }
    
    
    /// 网络变化
    @objc dynamic func networkDidChanged(notifi: Notification) {
        guard isRefreshTitle == true else {
            return
        }
        let isConnection = DFWAppNetworkMonitor.isConnection()
        let title = isConnection ? "net_error_refresh_tip" : "title.network.fail"
        self.titleLabel.text = title
        
        isRefreshTitle = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            self?.isRefreshTitle = true
        }
    }
    
    
}
