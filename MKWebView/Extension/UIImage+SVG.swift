//
//  UIImage+SVG.swift
//  DongFuWang
//
//  Created by sunshine on 2023/5/29.
//

import UIKit
import SVGKit
extension UIImage {
    /// 获取svg image
    @objc dynamic static func svgImage(imageName: String, id: String, size: CGSize, fillColor: UIColor) -> UIImage? {
        let svgImage = SVGKImage(named: imageName)
        svgImage?.size = size
        guard let layer: CAShapeLayer = svgImage?.layer(withIdentifier: id) as? CAShapeLayer else {
            return nil
        }
        layer.fillColor = fillColor.cgColor
       
        return svgImage?.uiImage
    }
 
    /// 获取svg image
    @objc dynamic static func svgImage(imageUrl: String, id: String, size: CGSize, fillColor: UIColor) -> UIImage? {
        let svgImage = SVGKImage(contentsOf: URL(string: imageUrl))
        svgImage?.size = size
        guard let layer: CAShapeLayer = svgImage?.layer(withIdentifier: id) as? CAShapeLayer else {
            return nil
        }
        layer.fillColor = fillColor.cgColor
        return svgImage?.uiImage
    }
}
