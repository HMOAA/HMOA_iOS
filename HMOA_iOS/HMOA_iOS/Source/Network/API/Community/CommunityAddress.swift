//
//  CommunityAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/30.
//

import Foundation

enum CommunityAddress {
    case fetchPostsByCategory
    case postCommnunityPost
    case fetchPostDetail(String)
}

extension CommunityAddress {
    var url: String {
        switch self {
        case .fetchPostDetail(let id):
            return "community/\(id)"
        case .fetchPostsByCategory:
            return "community/category"
        case .postCommnunityPost:
            return "community/save"
            
        }
    }
}
