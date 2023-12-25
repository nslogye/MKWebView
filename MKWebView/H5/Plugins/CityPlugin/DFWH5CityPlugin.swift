//
//  DFWH5CityPlugin.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2020/12/17.
//

import UIKit


class DFWH5CityPlugin: DFWH5Plugin {
    
    
    override func handlerJsMessage(message: Dictionary<String, Any>) {
        super.handlerJsMessage(message: message)
        let methodName = message["methodName"] as! String
        switch DFWWebCommandMethodType(rawValue: methodName)! {
        case .GetCityInfo:
            self.getCityInfo(message: message)
            break
        case .SwitchCityInfo:
            self.switchCityInfo(message: message)
            break
        default: break
        }
    }
    
     
    @objc dynamic private func getCityInfo(message: Dictionary<String, Any>) {
//        var respData = self.getRespDataWith(message: message)
//        var data = self.getDataDict()
//        let cityName = DFWLocationCachesManager.singletion().getCityCaches()?.currentCityName ?? DFSDefaultCityName
//        let cityId = DFWLocationCachesManager.singletion().getCityCaches()?.currentCityId ?? DFSDefaultCityId
//        data["cityName"] = cityName
//        // 修改于：2023年9月25日
//        /*
//         修改前
//         data["city"] = cityId
//         修改原因：
//         - 1、部分h5反映是通过cityId读取的城市id
//         - 2、跟安卓同步
//         */
//        data["city"] = cityName
//        data["cityId"] = cityId
//        //获取address信息
//        DFSApiCityService.getCityAddressInfo(cityId: cityId) { (object, code, message) in
//            if code == DFWResponseStatusCode.Success.rawValue {
//                let model = object as! DFSCityAddressInfoModel
//                if let dict = model.getAddressDict() {
//                    let jsonString = dict.convertToString() ?? ""
//                    data["address"] = jsonString
//                }
//            }
//            //返回success
//            respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
//            respData["data"] = data
//            print("-------",respData)
//            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
//        }
        
    }
    
    @objc dynamic private func switchCityInfo(message: Dictionary<String, Any>) {
//        var respData = self.getRespDataWith(message: message)
//        let params = self.getJsParams(message: message)
//        if params?["city"] == nil {
//            respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
//            respData["msg"] = "city不能为空"
//            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
//            return
//        }
//        if params?["cityId"] == nil {
//            respData["code"] = DFWWebCommandCallBackCodeType.Failure.rawValue
//            respData["msg"] = "cityId不能为空"
//            self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
//            return
//        }
//        var cityIdString: String = DFSDefaultCityId
//        if let cityId = params!["cityId"] as? Int {
//            cityIdString = String(cityId)
//        }
//        if let cityId = params!["cityId"] as? String {
//            cityIdString = cityId
//        }
//        var cityNameString: String = DFSDefaultCityName
//        if let city = params!["city"] as? String {
//            cityNameString = city
//        }
//        //这里直接存cookie
//        let cacheModel = DFSCurrentCityModel()
//        cacheModel.city = DFSCurrentCityInfoModel()
//        cacheModel.currentCityId = cityIdString
//        cacheModel.currentCityName = cityNameString
//        DFWLocationCachesManager.singletion().cachesCityData(data: cacheModel.dictionary(), webview: self.webView)
//        //跑接口
//        let token = DFWUserInfoManager.singletion().getLoginToken()
//        DFSApiCityService.chooseCityInfo(cityId: cityIdString,
//                                         cityName: cityNameString,
//                                         token: token) { (data, code, message) in
//            
//        }
//        respData["code"] = DFWWebCommandCallBackCodeType.Success.rawValue
//        self.delegate?.commandJsCompletedCallback(respData: respData, webView: self.webView)
    }
    
    
}
