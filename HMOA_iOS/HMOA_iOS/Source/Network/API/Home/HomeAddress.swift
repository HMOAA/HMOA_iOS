//
//  HomeAddress.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/13.
//

import Foundation

enum HomeAddress {
    case getFirstHomeData
    case getsecondHomeData
}

extension HomeAddress {
    var url: String {
        switch self {
        case .getFirstHomeData:
            return "perfume/findtest"
        
        case .getsecondHomeData:
            return "perfume/findtest2"
        }
    }
}
