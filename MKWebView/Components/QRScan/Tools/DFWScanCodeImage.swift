import Vision
import UIKit
import swiftScan
class DFWScanCodeImage: NSObject {
    /// 扫码
    @objc dynamic class func scanQrImage(image: UIImage?, block: @escaping (_ qrString: String?) -> Void){
        guard let _image: UIImage = image else {
            block(nil)
            return
        }
        // 本地扫码
        parseBarCode(img: _image) { qrString in
            if kStringIsEmpty(str: qrString) {
                // 没有扫码到结果，尝试使用LBXScanWrapper试一下
                let _qr = parseBarCodeByLBXScan(image: _image)
                block(_qr)
            } else {
                block(qrString)
            }
        }
        
    }
    /// 通过LBXScanWrapper扫码
    @objc dynamic class private func parseBarCodeByLBXScan(image: UIImage) -> String {
        let arrayResult = LBXScanWrapper.recognizeQRImage(image: image)
        if arrayResult.count > 0,
           let result = arrayResult[0].strScanned,
            result.isEmpty == false {
            return result
        }
        return ""
    }
    
    /// 识别二维码和条形码
    @objc dynamic class private func parseBarCode(img: UIImage, block: @escaping (_ qrString: String?) -> Void) {
        guard let cgimg = img.cgImage else {
            block(nil)
            return
        }
        let request = VNDetectBarcodesRequest { req, err in
            if let error = err {
                block(nil)
                print("parseBarCode error: \(error)")
                return
            }
            guard let results = req.results, let firstQR = results.first else {
                block(nil)
                return
            }
            if let barcode = firstQR as? VNBarcodeObservation,
               let value = barcode.payloadStringValue {
                if barcode.symbology == .qr { // 二维码
                    print("qrcode: \(value)")
                    block(value)
                } else { // 条形码
                    block(value)
                    print("barcode: \(value), \(barcode.symbology.rawValue)")
                }
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgimg)
        do {
            try handler.perform([request])
        } catch {
            block(nil)
            print("parseBarCode error: \(error)")
        }
    }
    /// 扫描图片二维码
//    @objc dynamic class func recognizeQRImage(image: UIImage?) -> String? {
//        guard let _image: UIImage = image else {
//            return nil
//        }
//        let arrayResult = LBXScanWrapper.recognizeQRImage(image: _image)
//        if arrayResult.count > 0,
//           let result = arrayResult[0].strScanned,
//            result.isEmpty == false {
//            return result
//        }
//        return nil
//    }
    
    
}
