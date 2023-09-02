//
//  Comment.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/02.
//

import Foundation

struct ResponseComment: Codable, Hashable {
    let commentCount: Int
    let comments: [Comment]
}

struct Comment: Codable, Hashable {
    let content: String
    let heartCount: Int
    let id: Int
    let nickname: String
    let perfumeId: Int
}
