//
//  HomeAddress.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/13.
//

import Foundation

enum HomeAddress {
    case getHomeData
}

extension HomeAddress {
    var url: String {
        switch self {
        case .getHomeData:
            return "perfume/findtest"
        }
    }
}
