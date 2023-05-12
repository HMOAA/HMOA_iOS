//
//  MyPageViewModel.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit

enum MyPageType: String, CaseIterable {
    case myLog = "10"
    case myProfile = "11"
     
    case openSource = "20"
    case policy = "21"
    case version = "22"
    
    case logout = "30"
    case deleteAccount = "31"

    var title: String {
        switch self {
        case .myLog:
            return "내 활동"
        case .myProfile:
            return "내 정보관리"
        case .openSource:
            return "오픈소스 라이브러리"
        case .policy:
            return "개인정보 처리방침"
        case .version:
            return "버전정보 1.0.0"
        case .logout:
            return "로그아웃"
        case .deleteAccount:
            return "계정삭제"
        }
    }
}
