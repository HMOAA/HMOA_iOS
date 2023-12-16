//
//  TotalPerfumeAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/15/23.
//

import Foundation

enum TotalPerfumeAddress {
    case fetchFirstMenu
    case fetchSecondMenu
    case fetchThirdMenu
}

extension TotalPerfumeAddress {
    var url: String {
        switch self {
        case .fetchFirstMenu:
            return "main/firstMenu"
        case .fetchSecondMenu:
            return "main/secondMenu"
        case .fetchThirdMenu:
            return "main/thirdMenu"
        }
    }
}
