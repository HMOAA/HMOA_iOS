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
    case putDeleteMagazineLike(Int)
    
    var url: String {
        switch self {
        case .fetchMagazines:
            return "magazine/list"
        case .fetchNewPerfumes:
            return "perfume/recentPerfume"
        case .fetchTopReviews:
            return "magazine/tastingComment"
        case .fetchMagazineDetail(let id):
            return "magazine/\(id)"
        case .putDeleteMagazineLike(let id):
            return "magazine/\(id)/like"
        }
    }
}
