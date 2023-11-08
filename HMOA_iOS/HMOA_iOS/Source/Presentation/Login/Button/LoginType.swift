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
            return "Google로 로그인"
        case .apple:
            return "Apple로 로그인"
        case .kakao:
            return "Kakaotalk로 로그인"
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
            return UIImage(named: "kakao")!
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .google:
            return .white
        case .apple:
            return .black
        case .kakao:
            return #colorLiteral(red: 1, green: 0.8980392157, blue: 0, alpha: 1)
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .apple:
            return 29
        case .google:
            return 24
        case .kakao:
            return 21
        }
    }
    
    var rightPadding: CGFloat {
        switch self {
        case .apple:
            return 114
        case .google:
            return 109
        case .kakao:
            return 93
        }
    }
    
}
 
