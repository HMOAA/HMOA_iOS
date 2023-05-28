//
//  LoginType.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/05/28.
//

import Foundation
import UIKit


enum LoginType {
    case google
    case apple
    case kakao
    
    var title: String {
        switch self {
        case .google:
            return "구글로 시작하기"
        case .apple:
            return "애플로 시작하기"
        case .kakao:
            return "카카오로 시작하기"
        }
    }
    
    var color: UIColor {
        switch self {
        case .google:
            return .black
        case .apple:
            return .white
        case .kakao:
            return .black
        }
        
    }
    
    var image: UIImage {
        switch self {
        case .google:
            return UIImage(named: "google")!
        case .apple:
            return UIImage(named: "apple")!
        case .kakao:
            return UIImage(named: "kakaotalk")!
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .google:
            return .white
        case .apple:
            return .black
        case .kakao:
            return #colorLiteral(red: 0.9983025193, green: 0.9065476656, blue: 0, alpha: 1)
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .google, .apple:
            return 80
        case .kakao:
            return 60
        }
    }
    
    var rightPadding: CGFloat {
        switch self {
        case .google, .apple:
            return 120
        case .kakao:
            return 108
        }
    }
    
}
 
