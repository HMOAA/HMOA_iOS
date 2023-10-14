//
//  MyPageViewModel.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit

enum MyPageType: String, CaseIterable {
    case myProfile = "00"
    
    case myLog = "10"
    case myInformation = "11"
     
    case terms = "20"
    case policy = "21"
    case version = "22"
    
    case inquireAccount = "30"
    case logout = "31"
    case deleteAccount = "32"

    var title: String {
        switch self {
        case .myProfile:
            return ""
        case .myLog:
            return "내 활동"
        case .myInformation:
            return "내 정보관리"
        case .terms:
            return "이용 약관"
        case .policy:
            return "개인정보 처리방침"
        case .version:
            return "버전정보 1.0.0"
        case .inquireAccount:
            return "1대1 문의"
        case .logout:
            return "로그아웃"
        case .deleteAccount:
            return "계정삭제"
        }
    }
}
