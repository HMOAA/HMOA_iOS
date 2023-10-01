//
//  CommunityModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/30.
//

import Foundation

struct CommunityDetail: Hashable, Codable {
    let author: String
    let category: String
    let content: String
    let id: Int
    let profileImgUrl: String
    let time: String
    let title: String
    let writed: Bool
}

struct CategoryList: Hashable, Codable {
    let category: String
    let title: String
}

struct CommunityCommentResponse: Codable, Hashable {
    let commentCount: Int
    let comments: [CommunityComment]
}

struct CommunityComment: Codable, Hashable {
    let author: String
    let commentId: Int
    let content, profileImg, time: String
    let writed: Bool
}
