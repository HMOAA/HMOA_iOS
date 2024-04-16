//
//  MyPageViewModel.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit

enum MyPageType: String, CaseIterable {
    case myProfile = "00"
    
    case myPerfume = "20"
    
    case myLog = "30"
    case myInformation = "31"
     
    case terms = "40"
    case policy = "41"
    case version = "42"
    
    case inquireAccount = "50"
    case logout = "51"
    case deleteAccount = "52"

    var title: String {
        switch self {
        case .myProfile:
            return ""
        case .myPerfume:
            return "나의 향수"
        case .myLog:
            return "내 활동"
        case .myInformation:
            return "내 정보관리"
        case .terms:
            return "이용 약관"
        case .policy:
            return "개인정보 처리방침"
        case .version:
            return "버전정보 1.0.3"
        case .inquireAccount:
            return "1대1 문의"
        case .logout:
            return "로그아웃"
        case .deleteAccount:
            return "계정삭제"
        }
    }
}
