//
//  DFWQRResultViewController.swift
//  DFMaxStore
//
//  Created by qianduan2731 on 2022/7/16.
//

import UIKit

class DFWQRResultViewController: DFWBaseRootViewController {
    @objc dynamic public var resultString : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setTopBarStyle(topBarStyle: DFWTopBarStyle.DFWTopBarStyleTitleWithLeftButton);
        self.navigationBar.setLeftButtonImage(leftButtonImage: UIImage.init(named: "dfs_return_black_icon"))
        self.setBarColor(barColor: UIColor.white, title: "扫描结果", titleColor: UIColor.black)
        self.respondsToLeftEvent {(button) in
            
        }
        self.view.backgroundColor = .white
        self.view.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(navigationMaxY+5.0)
            make.left.equalToSuperview().offset(5.0)
            make.right.equalToSuperview().offset(-5.0)
        }
        self.textLabel.text = resultString
        // Do any additional setup after loading the view.
    }
    @objc lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = DFW_ColorFromHexColor(hexColor: "#333333")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
