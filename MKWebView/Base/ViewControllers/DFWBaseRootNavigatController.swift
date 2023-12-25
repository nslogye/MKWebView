//
//  DFWBaseRootNavigatController.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/3.
//

import UIKit

class DFWBaseRootNavigatController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        return super.popViewController(animated: animated)
    }
    // 重写这两个方法 修复 控制 preferredStatusBarStyle 方法无效
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
