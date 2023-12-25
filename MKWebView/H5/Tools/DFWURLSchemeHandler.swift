//
//  DFWURLSchemeHandler.swift
//  DongFuWang
//
//  Created by lianggq on 2020/11/11.
//

import UIKit
import Foundation
import WebKit
import CoreServices


class DFWURLSchemeHandler: NSObject,WKURLSchemeHandler {
    @objc private static var __showCookie = false
    
    @available(iOS 11.0, *)
    @objc dynamic func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
//        let isUseLocalFile = self.isfindLocalURLForSchemeTask(urlSchemeTask)
//        if(isUseLocalFile){
//            return
//        }
//        guard let url = urlSchemeTask.request.url else {
//            return
//        }
//        var request = urlSchemeTask.request
//        if url.scheme?.contains("dfwapp") == true {
//            let urlStr = url.absoluteString
//            let newURLString = urlStr.replacingOccurrences(of: "dfwapp", with: "http")
//            if let newURL = URL.init(string: newURLString) {
//                let newReq = request as NSURLRequest?
//                let mutaleURLReqeust = newReq?.mutableCopy() as? NSMutableURLRequest
//                mutaleURLReqeust?.url = newURL
//                if(mutaleURLReqeust != nil){
//                    request = (mutaleURLReqeust! as URLRequest)
//                }
//            }
//        }
//        weak var task = urlSchemeTask
//        print("origin = \(String(describing: task?.request.url?.absoluteString)), remote = \(String(describing: request.url?.absoluteString))")
//        DFWHttpReqeustManager.httpRawRequestWith(request: request) { (resp, object, error) in
//            if(error != nil){
//                task?.didFailWithError(error!)
//            }else{
//                if(resp != nil) {
//                    task?.didReceive(resp!)
//                }
//                if(object != nil){
//                    var data: Data?
//                    if(object is Data){
//                        data = object as? Data
//                        task?.didReceive(data!)
//                    }
//                }
//                task?.didFinish()
//            }
//            
//        }
        
    }
    
    @available(iOS 11.0, *)
    @objc dynamic func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
//    @available(iOS 11.0, *)
//    @objc dynamic private func isfindLocalURLForSchemeTask(_ urlSchemeTask: WKURLSchemeTask?) -> Bool {
//        guard let url = urlSchemeTask?.request.url else {
//            return false
//        }
//        let path = url.path
//        let h5Path = DFWPackageDownloadManager.getOrCreateH5PackagePath()
//        let fileURL = h5Path.appendingPathComponent(path)
//        let fs = FileManager.default
//        if(fs.fileExists(atPath: fileURL.path)){
//            let ext = fileURL.pathExtension
//            let mimeType = self.getMIMETypeFor(ext)
//            print("web schemeHandler to local = \(url.absoluteString)")
//            guard let data = try? Data.init(contentsOf: fileURL) else {
//                return false
//            }
//            let response = URLResponse.init(url: url, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: nil)
//            urlSchemeTask?.didReceive(response)
//            urlSchemeTask?.didReceive(data)
//            urlSchemeTask?.didFinish()
//            return true
//        }
//        return false
//    }
    
    
    @objc dynamic private func getMIMETypeFor(_ fileExt: String) -> String {
        let utiType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExt as CFString, nil)?.retain().takeRetainedValue()
        if(utiType != nil){
            if let mimeType = UTTypeCopyPreferredTagWithClass(utiType!, kUTTagClassMIMEType) {
                let extString = mimeType.retain().takeRetainedValue()
                return extString as String
            }
        }
        return "application/octet-stream"
    }
    
}
