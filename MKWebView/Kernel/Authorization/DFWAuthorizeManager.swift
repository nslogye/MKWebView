//
//  DFWAuthorizeManager.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/5.
//

import UIKit
import Photos
import AVFoundation
import CoreLocation

final class DFWAuthorizeManager: NSObject {
    
    //authorized 是否授权 ， requested 是否请求用户选择授权行为
    public typealias DFWAuthorizedStatus = (_ authorized: Bool, _ requested: Bool) -> Void

    
    /// 是否有相册访问权限
    ///
    /// - Parameter status: 返回状态
    @objc dynamic public class func isAccessedAlbumLibrary(status:@escaping DFWAuthorizedStatus) {
        var s: PHAuthorizationStatus!
        if #available(iOS 14, *) {
            //ios14 limit 设置
            let level = PHAccessLevel.readWrite
            s = PHPhotoLibrary.authorizationStatus(for: level)
        } else {
            s = PHPhotoLibrary.authorizationStatus()
        }
        if (s == PHAuthorizationStatus.denied || s == PHAuthorizationStatus.restricted){
            status(false,false)
        }else if (s == PHAuthorizationStatus.notDetermined){
            let requestAuthorization = { (_ access: PHAuthorizationStatus) in
                DispatchQueue.main.async {
                    if access == .denied {
                        status(false,true)
                    }else {
                        status(true,true)
                    }
//                    if #available(iOS 14, *) {
//                        if access == .limited {
//                        }
//                    }
                }
            }
            
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { (access) in
                    requestAuthorization(access)
                }
            } else {
                PHPhotoLibrary.requestAuthorization { (access) in
                    requestAuthorization(access)
                }
            }
            
        }else {
            status(true,false)
        }
    }
    
    
    /// 是否有相机访问权限
    ///
    /// - Parameter status:返回状态
    @objc dynamic public class func isAcesssedCamera(status:@escaping DFWAuthorizedStatus) {
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == .denied || vStatus == .restricted) {
            status(false,false)
        }else if (vStatus == .notDetermined){
            AVCaptureDevice.requestAccess(for: .video) { (authorized) in
                DispatchQueue.main.async {
                    status(authorized,true)
                }
            }
        }else {
            status(true,false)
        }
    }
    
    /// 是否有定位访问权限
    ///
    /// - Parameter status:返回状态
    @objc dynamic public class func isAccessedLocation(status:@escaping DFWAuthorizedStatus) {
        let s = CLLocationManager.authorizationStatus()
        if (s == .denied || s == .restricted){
            status(false,false)
        }else if (s == .notDetermined){
            status(true,true)
        }else {
            status(true,false)
        }
    }
    
    /// 麦克风权限
    @objc dynamic public class func isAccessMicroPhone(status:@escaping DFWAuthorizedStatus){
        let vStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(vStatus == .denied || vStatus == .restricted) {
            status(false,false)
        }else if (vStatus == .notDetermined){
            AVCaptureDevice.requestAccess(for: .audio) { (authorized) in
                DispatchQueue.main.async {
                    status(authorized,true)
                }
            }
        }else {
            status(true,false)
        }
    }
    
    @objc dynamic public class func requestAuthorizedFor(_ type: String, staus:@escaping DFWAuthorizedStatus) {
        switch type {
        case "camera":
            self.isAcesssedCamera(status: staus)
            break
        case "photo":
            self.isAccessedAlbumLibrary(status: staus)
            break
        case "microphone":
            self.isAccessMicroPhone(status: staus)
            break
        case "location":
            self.isAccessedLocation(status: staus)
        default:
            staus(false, false )
            break
        }
    }
    
    
    ///跳转app设置
    @objc dynamic public class func actionToOpenSettings(){
        let url = URL.init(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                
            }
        }
    }

}
