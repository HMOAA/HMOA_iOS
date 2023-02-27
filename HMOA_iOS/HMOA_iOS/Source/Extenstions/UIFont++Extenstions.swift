//
//  UIFont++Extenstions.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/23.
//

import UIKit
import Pretendard

enum Fonts {
    case pretendard_semibold
    case pretendard_medium
    case pretendard_light
    case pretendard // pretendard_regular와 같음
    case slabo27px
}

extension UIFont {
    
    static func customFont(_ font: Fonts, _ size: CGFloat) -> UIFont {
        switch font {
        case .pretendard_semibold:
            return .pretendardFont(ofSize: size, weight: .semibold)
        case .pretendard_medium:
            return .pretendardFont(ofSize: size, weight: .medium)
        case .pretendard_light:
            return .pretendardFont(ofSize: size, weight: .light)
        case .pretendard:
            return .pretendardFont(ofSize: size, weight: .regular)
        case .slabo27px:
            return UIFont(name: "Slabo27px-Regular", size: size)!
        }
    }
}
