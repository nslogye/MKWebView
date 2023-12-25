//
//  DFWNavigationService.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/10/27.
//

import UIKit
import Foundation
class DFWNavigationService: NSObject {
    @objc dynamic class func to(URLString:String, params:Dictionary<String, Any>,
                  backBlock:@escaping ((_ block: Dictionary<String, Any>) -> Void )) ->Bool{
        if URLString.isEmpty {
            return false
        }
        let url = URLString.lowercased()
        
        if url.hasPrefix("http://")||url.hasPrefix("https://")||url.hasPrefix("file://") {
            
            
            let allParams = NSMutableDictionary(dictionary: params)
            allParams["web_url"] = URLString;
//            //undo 通用webViewController
//            [YUHManager showViewControllerWithName:@"WebContainerController" param:allParams];
            return true;
        }
        let canRoute:Bool = DFWBaseOpenURL.handleOpenURLString(URLString: URLString, extraParams: params as NSDictionary, backBlock: backBlock)
        return canRoute;
    }
    
    @discardableResult
    @objc dynamic class func to(URLString:String) -> Bool {
        return DFWNavigationService.to(URLString: URLString, params: [:]) { (block) in
            
        }
    }
    
    @discardableResult
    @objc dynamic class func to(URLString:String, params:Dictionary<String, Any>) -> Bool {
        return DFWNavigationService.to(URLString: URLString, params: params) { (block) in
            
        }
    }
    
    
}

