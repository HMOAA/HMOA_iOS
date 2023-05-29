//
//  LoginAddress.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

enum LoginAddress {
    case google
    case apple
    case kakao

}

extension LoginAddress {
    var url: String {
        switch self {
        case .google:
            return "login/oauth2/GOOGLE"
        case .apple:
            return "login/oauth2/APPLE"
        case .kakao:
            return "login/oauth2/KAKAO"
        }
    }
}
