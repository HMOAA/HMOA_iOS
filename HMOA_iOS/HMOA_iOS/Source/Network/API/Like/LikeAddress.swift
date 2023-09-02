//
//  LikeAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/28.
//

import Foundation

enum LikeAddress {
    case like(String)
    case fetchLikeList
}

extension LikeAddress {
    var url: String {
        switch self {
        case .like(let id):
            return "perfume/\(id)/like"
        case .fetchLikeList:
            return "perfume/like"
        }
    }
}
