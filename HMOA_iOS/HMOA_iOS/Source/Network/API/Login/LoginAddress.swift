//
//  LoginAddress.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

enum LoginAddress {
    case postToken

}

extension LoginAddress {
    var url: String {
        switch self {
        case .postToken:
            return "login/oauth2/GOOGLE"
        }
    }
}
