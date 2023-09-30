//
//  CommunityModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/30.
//

import Foundation

struct CommunityDetail: Hashable, Codable {
    let author: String
    let catery: String
    let content: String
    let id: Int
    let profileImgUrl: String
    let time: String
    let title: String
    let wirted: Bool
}

struct CategoryList: Hashable, Codable {
    let category: String
    let title: String
}
