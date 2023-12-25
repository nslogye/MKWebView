//
//  DFWBaseOpenURL.swift
//  DongFuWang
//
//  Created by Ye.Sir on 2020/10/27.
//

import UIKit

let DFW_OPENURL_PAGE_SCHEME = "dfwapp://page?"
let DFW_OPENURL_EVENT_SCHEME = "dfwapp://event?"

/*
 dfwapp://page?iosPageName=DFWMainViewController&entryStyle=0&animated=1&parameters={}
 
 dfwapp://event?iosHandleClass=DFWMainViewController&iosMethodName=buttonClick&parameters={}
 
 */


/**
 *  解析参数
 *  可能ViewController需要的参数是对象，但是通过协议只能传入string类型，需要ViewController转成自己需要的对象
 *
 *  @param params 参数字典
 */
@objc protocol DFWBaseOpenURLProtocol:NSObjectProtocol {
    func pageParameters(params:Dictionary<String, Any>,backBlock: @escaping ((_ block: Dictionary<String, Any>) -> Void ))
}


@objc enum DFWOpenURLType: NSInteger {

    case App = 1
    
    case Web = 2
}


class DFWBaseOpenURLParamsModel: MKBaseRootModel {
    
    @objc var url: String?
    
    @objc var pageName: String?
    
    @objc var pageData: Dictionary<String, Any>?
    
    @objc var methodName: String?

}

class DFWBaseOpenURLModel: MKBaseRootModel {
    
    @objc var type: String?
    
    @objc var params: DFWBaseOpenURLParamsModel?

}

class DFWBaseOpenURL: NSObject{
    
    @objc public static let pageMappings = [
        "city":        "DFSChooseCityViewController",
        "user":        "DFSUserCenterViewController",
        "userdetail":  "DFSUserInfoDetailViewController",
        "setting":     "DFSSettingViewController",
        "about":       "DFWAboutViewController",
        "feedback":    "DFWFeedbackTypeViewController",
        "services":    "DFWWebViewController",
    ]
    
    /// 通过工page映射找到viewController类
    /// - Parameter pageName:   pageName
    /// - Returns:              clsName for viewController, not find is ""
    @objc dynamic public class func getPageClassName(_ pageName: String) -> String? {
        let clsName = (self.pageMappings[pageName]) ?? ""
        return clsName
    }
    
    
    /// 通过数据跳转app各页面
    /// - Parameter pageDatas: pageDatas
    @objc dynamic public class func handleOpenInPageDatas(_ pageDatas: Dictionary<String, Any>) {
        var type: NSInteger?
        if let val = pageDatas["type"] as? NSInteger {
            type = val
        }
        if let val = pageDatas["type"] as? String {
            type = NSInteger(val)
        }
        guard let params = pageDatas["params"] as? Dictionary<String, Any> else {
            return
        }
        var pageClassName: String?
        var pageParams = Dictionary<String, Any>()
        if type == DFWOpenURLType.App.rawValue  { //跳app页面
            let pageName = (params["pageName"] as? String) ?? ""
            pageClassName = self.getPageClassName(pageName)
            if let pageData = pageDatas["pageData"] as? Dictionary<String, Any> {
                pageParams = pageData
            }
        }else if type == DFWOpenURLType.Web.rawValue { //跳web页面
            pageClassName = "DFWWebViewController"
            //url必须参数
            let url = (params["url"] as? String) ?? ""
            pageParams["requestUrlStr"] = url
        }
        if pageClassName != nil {
            let jumpUrl = "dfwapp://page?iosPageName=" + pageClassName! + "&entryStyle=0&animated=0"
            DFWBaseOpenURL.handleOpenURLString(URLString: jumpUrl, extraParams: pageParams as NSDictionary) { block in
                
            }
        }
    }
    
    
    /**
     *  解析OpenURL协议并跳转
     *
     *  @param URLString   协议字符串
     *  @param extraParams 附加参数
     *
     *  @return 是否成功解析
     */
    @discardableResult
    @objc dynamic class func handleOpenURLString(URLString:String,extraParams:NSDictionary,
                                   backBlock:@escaping ((_ block: Dictionary<String, Any>) -> Void )) -> Bool {
        if URLString.hasPrefix(DFW_OPENURL_PAGE_SCHEME) {
            return DFWBaseOpenURL.handleOpenPageURLString(URLString: URLString, extraParams: extraParams, backBlock:backBlock)
        }else if URLString.hasPrefix(DFW_OPENURL_EVENT_SCHEME){
            return false
        }else{
            return false
        }
    }
    @objc dynamic class func isNilOrEmpty(string:String) -> Bool {
        if !string.isEmpty {
            return false
        }
        return true
    }
    
    /// 解析参数
    /// - Parameter URLString: URLString description
    /// - Returns: description
    @objc dynamic class func URLParams(URLString:String) -> NSDictionary? {
        let url = NSURL.init(string: URLString)
        let query = url?.query
        if query!.isEmpty {
            return nil
        }
        let array:NSArray =  query!.components(separatedBy: "&") as NSArray
        let params = NSMutableDictionary.init()
        for paramString in array {
            let keyValue:NSArray = (paramString as AnyObject).components(separatedBy:"=") as NSArray
            if keyValue.count < 2{
                continue
            }else{
                let key = keyValue.firstObject as! NSString
                let value = keyValue.lastObject as! NSString
                let newKey = key.removingPercentEncoding! as NSString
                let newValue = value.removingPercentEncoding! as NSString
                params[newKey] = newValue
                
                
            }
        }
        return params
    }
    ///页面类型跳转
    @objc dynamic class func handleOpenPageURLString(URLString:String,extraParams:NSDictionary,
                                       backBlock: @escaping ((_ block: Dictionary<String, Any>) -> Void )) -> Bool {
        var canHandle = true
        if URLString.hasSuffix(DFW_OPENURL_PAGE_SCHEME) {
            return false
        }
        let params = DFWBaseOpenURL.URLParams(URLString: URLString)!
        let controllerName = params["iosPageName"] as! String
        //1:动态获取命名空间
        guard  let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return true
        }
        let spaceClsName = spaceName + "." + controllerName //VCName:表示试图控制器的类名
        var vcClass: AnyClass? = DFWFixRunTimeHandle.classFromString(spaceClsName)
        if vcClass == nil {
            vcClass = DFWFixRunTimeHandle.classFromString(controllerName)
        }
        //VCName:表示试图控制器的类名
         // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeClass = vcClass as? UIViewController.Type else {
             print("vcClass不能当做UIViewController")
            return true
         }
        
        if self.isNilOrEmpty(string:controllerName) {
            canHandle = false
        }else{
            let storyboardName = params["storyboardName"] as? String
            let nibName =  params["nibName"] as? String
            let entryStyle:Int = Int(params["entryStyle"] as! String)!
            let animatedInt:Int = Int(params["animated"] as! String)!
            var animated = true
            if animatedInt == 0 {
                animated = true
            }else{
                animated = false
            }
            let parameters = params["parameters"] as? NSDictionary
            var viewController:UIViewController?
            if (storyboardName != nil) {
                let storyboard:UIStoryboard = UIStoryboard.init(name: storyboardName! , bundle: nil)
                viewController = storyboard.instantiateViewController(withIdentifier: NSStringFromClass(typeClass))
            }else if(nibName != nil){
                
                viewController = typeClass.init(nibName: nibName!, bundle: nil)
            }else{
                viewController = typeClass.init()
            }
            //协议参数转化成property
//            if (parameters != nil) &&  ((viewController?.responds(to: Selector.init("pageParameters:backBlock"))) != nil){
//                viewController?.perform(Selector.init("pageParameters:backBlock"), with: parameters! , with:backBlock)
//            }
            if parameters != nil {
                if ((viewController?.responds(to: #selector(DFWBaseOpenURLProtocol.pageParameters(params:backBlock:)))) != nil){
                    viewController?.perform(#selector(DFWBaseOpenURLProtocol.pageParameters(params:backBlock:)), with: parameters, with: backBlock)
                }
            }
            switch entryStyle {
            case 0:
                DFWManager.showViewController(viewController: viewController!, param: extraParams, animated: animated)
                break
            case 1:
                DFWManager.showViewController(viewController: viewController!, param: extraParams, animated: animated)
                break
            case 2:
                DFWManager.showViewController(viewController: viewController!, param: extraParams, animated: animated)
                break
            default:
                break
            }
            
        }
        return canHandle
        
    }
    ///事件类型跳转
    @objc dynamic class func handleOpenEventURLString(URLString:String,extraParams:NSDictionary) -> Bool {
        if !URLString.hasPrefix(DFW_OPENURL_EVENT_SCHEME) {
            return false
        }
        let params = DFWBaseOpenURL.URLParams(URLString: URLString)!
        let controllerName:String = params["iosHandleClass"] as! String
        //1:动态获取命名空间
        guard  let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return true
        }
        let spaceClsName = spaceName + "." + controllerName //VCName:表示试图控制器的类名
        var vcClass: AnyClass? = DFWFixRunTimeHandle.classFromString(spaceClsName)
        if vcClass == nil {
            vcClass = DFWFixRunTimeHandle.classFromString(controllerName)
        }
        //VCName:表示试图控制器的类名
         // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeClass = vcClass as? UIViewController.Type else {
             print("vcClass不能当做UIViewController")
            return true
         }
        let methodNew:String = params["iosMethodName"] as! String
        let methodName:String = methodNew.removingPercentEncoding!
        if self.isNilOrEmpty(string:controllerName) || self.isNilOrEmpty(string:methodName) {
            return false
        }
        var canHandle:Bool = false
        let parameters:NSDictionary = params["parameters"] as! NSDictionary
        let method:Selector = NSSelectorFromString(methodName)
        if (typeClass.responds(to: method)) {
            typeClass.perform(method, with: parameters)
            canHandle = true
            return canHandle
        }
        let viewController =  UIViewController.init()
        if (viewController.method(for: method) != nil) {
            let entryStyle:Int = params["entryStyle"] as! Int
            let animatedInt:Int = Int(params["animated"] as! String)!
            var animated = true
            if animatedInt == 0 {
                animated = true
            }else{
                animated = false
            }
            switch entryStyle {
            case 0:
                DFWManager.showViewController(viewController: viewController, param: extraParams, animated: animated)
                break
            case 1:
                DFWManager.showViewController(viewController: viewController, param: extraParams, animated: animated)
                break
            case 2:
                DFWManager.showViewController(viewController: viewController, param: extraParams, animated: animated)
                break
            default: break
                
            }
            viewController.perform(method, with: parameters)
            
        }
        return canHandle
    }
    
}
