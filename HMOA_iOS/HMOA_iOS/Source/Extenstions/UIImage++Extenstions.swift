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
}
