//
//  CommunityModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/30.
//

import Foundation

struct CommunityDetail: Hashable, Codable {
    let id: Int
    let title: String
    let category: String
    let content: String
    let author: String
    let profileImgUrl: String
    let imagesCount: Int
    let communityPhotos: [CommunityPhoto]
    let myProfileImgUrl: String?
    let time: String
    let writed: Bool
}

struct CommunityPhoto: Hashable, Codable {
    let photoId: Int
    let photoUrl: String
}

struct CategoryList: Hashable, Codable {
    let communityId: Int
    let category: String
    let title: String?
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

