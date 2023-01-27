//
//  UIFont++Extenstions.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/23.
//

import UIKit

enum Fonts {
    case pretendard
    case slabo27px
}

extension UIFont {
    
    static func customFont(_ font: Fonts, _ size: CGFloat) -> UIFont {
        switch font {
        case .pretendard:
            return UIFont(name: "Pretendard-Regular", size: size)!
        case .slabo27px:
            return UIFont(name: "Slabo27px-Regular", size: size)!
        }
    }
}
