//
//  UIImageExtension.swift
//  DFMaxStore
//
//  Created by sunshine on 2023/7/17.
//

import UIKit


//MARK: 制作字符串二维码图片
extension UIImage {
    
    
    /// 通过字符串生成正方形二维码
    /// - Parameters:
    ///   - code:       二维码字符串
    ///   - size:       图片size
    /// - Returns:      返回image
    public class func imageWithQRCode(_ code: String, size: CGFloat) -> UIImage? {
        if code.count == 0 || size <= 0.0 {
            return nil
        }
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = code.data(using: .utf8)
        //通过kvo方式给一个字符串，生成二维
        filter?.setValue(data, forKey: "inputMessage")
        //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大 （L, M, Q, H）
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        //拿到CIImage图片
        if let outPutImage = filter?.outputImage {
            return self.createImageFromCIImage(outPutImage, size: size)
        }
        return nil
    }
    
    private class func createImageFromCIImage(_ ciImage: CIImage, size: CGFloat) -> UIImage? {
        let extent = ciImage.extent.integral
        let scale = min(size / extent.size.width, size / extent.size.height)
        let width = extent.size.width * scale
        let height = extent.size.height * scale
        // 创建依赖于设备的灰度颜色通道
        let space = CGColorSpaceCreateDeviceGray()
        // 创建图形上下文
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: space, bitmapInfo: 0)
        // 设置缩放
        bitmapContext?.scaleBy(x: scale, y: scale)
        // 设置上下文渲染等级
        bitmapContext?.interpolationQuality = .none
        // 上下文
        let context = CIContext(options: nil)
        // 创建 cgImage
        guard let cgImage = context.createCGImage(ciImage, from: extent) else { return nil }
        // 绘图
        bitmapContext?.draw(cgImage, in: extent)
        // 从图形上下文中创建图片
        guard let scaledImage = bitmapContext?.makeImage() else { return nil }
        // 得到图片
        let image = UIImage(cgImage: scaledImage)
        return image
    }
    
}

 
