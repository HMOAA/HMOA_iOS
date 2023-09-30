//
//  SecondDetail.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/12.
//

import Foundation


struct SecondDetail: Codable, Hashable {
    let commentInfo: CommentInfo
    let similarPerfumes: [SimilarPerfume]
}



struct CommentInfo: Codable, Hashable {
    let commentCount: Int
    let comments: [Comment]
}


struct Comment: Codable, Hashable {
    let content, createAt: String
    var heartCount: Int
    let id: Int
    let liked: Bool
    let nickname: String?
    let perfumeId: Int
    let profileImg: String
    let writed: Bool
}

struct SimilarPerfume: Codable, Hashable {
    let brandName, perfumeImgUrl, perfumeName: String
}

