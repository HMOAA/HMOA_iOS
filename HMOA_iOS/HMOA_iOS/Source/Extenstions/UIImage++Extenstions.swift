//
//  UIImage++Extenstions.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/15/23.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 이미지 리사이징으로 크기 줄이기
    /// - Parameters:
    ///   - targetSize: image Size
    /// - Returns: 리사이징된 이미지
    func resize(targetSize: CGSize, opaque: Bool = false) -> UIImage? {
        
            UIGraphicsBeginImageContextWithOptions(targetSize, opaque, 1)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.interpolationQuality = .high
            
            let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
            draw(in: newRect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
            return newImage
        }
    
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func withAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
