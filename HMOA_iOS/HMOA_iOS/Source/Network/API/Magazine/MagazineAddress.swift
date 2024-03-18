//
//  MagazineAddress.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/11/24.
//

import Foundation

enum MagazineAddress {
    case fetchMagazines
    case fetchNewPerfumes
    case fetchTopReviews
    
    var url: String {
        switch self {
        case .fetchMagazines:
            return ""
        case .fetchNewPerfumes:
            return ""
        case .fetchTopReviews:
            return ""
        }
    }
}
