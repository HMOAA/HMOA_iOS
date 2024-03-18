//
//  MyLogComment.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 3/12/24.
//

import Foundation

struct MyLogComment: Codable, Hashable {
    let content, createAt: String
    var heartCount: Int
    let id: Int
    var liked: Bool
    let nickname: String?
    let parentId: Int
    let profileImg: String
    let writed: Bool
}
