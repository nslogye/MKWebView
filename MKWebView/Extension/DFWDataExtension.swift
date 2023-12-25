//
//  DFWDataExtension.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2021/5/13.
//

import Foundation


extension Data {
    
    func getImageType() -> String?  {
        if self.count <= 0 {
            return nil
        }
        var buffer = [UInt8](repeating: 0, count: 1)
        self.copyBytes(to: &buffer, count: 1)
        //
        switch buffer {
        case [0xFF]: return "jpeg"
        case [0x89]: return "png"
        case [0x47]: return "gif"
        case [0x49],[0x4D]: return "tiff"
        case [0x52] where self.count >= 12:
            if let str = String(data: self[0...11], encoding: .ascii), str.hasPrefix("RIFF"), str.hasSuffix("WEBP") {
                return "webp"
            }
        case [0x00] where self.count >= 12:
            if let str = String(data: self[8...11], encoding: .ascii) {
                let HEICBitMaps = Set(["heic", "heis", "heix", "hevc", "hevx"])
                if HEICBitMaps.contains(str) {
                    return "heic"
                }
                let HEIFBitMaps = Set(["mif1", "msf1"])
                if HEIFBitMaps.contains(str) {
                    return "heif"
                }
            }
        default: break;
        }
        return nil  //不是图片类型
    }
    
}
