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
    case fetchMagazineDetail(Int)
    
    var url: String {
        switch self {
        case .fetchMagazines:
            return ""
        case .fetchNewPerfumes:
            return ""
        case .fetchTopReviews:
            return ""
        case .fetchMagazineDetail(let id):
            return "magazine/\(id)"
        }
    }
}
