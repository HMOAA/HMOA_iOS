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
    case fetchCommunityDetail(String)
    case fetchCommunityComment(String)
    case postComment(String)
    case editOrDeleteComment(String)
    case putOrDeleteCommunityPost(String)
}

extension CommunityAddress {
    var url: String {
        switch self {
        case .fetchCommunityDetail(let id):
            return "community/\(id)"
        case .fetchPostsByCategory:
            return "community/category"
        case .postCommnunityPost:
            return "community/save"
        case .fetchCommunityComment(let id):
            return "community/comment/\(id)/findAll"
        case .postComment(let id):
            return "community/comment/\(id)/save"
        case .editOrDeleteComment(let id):
            return "community/comment/\(id)"
        case .putOrDeleteCommunityPost(let id):
            return "community/\(id)"
            
        }
    }
}
