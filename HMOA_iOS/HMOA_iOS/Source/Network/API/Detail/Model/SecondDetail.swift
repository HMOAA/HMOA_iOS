//
//  SecondDetail.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/12.
//

import Foundation


struct SecondDetail: Codable, Hashable {
    let age: Age
    let commentInfo: CommentInfo
    let gender: Gender
    let similarPerfumes: [SimilarPerfume]
    let weather: Weather
}

struct Evaluation: Hashable {
    let age: Age
    let gender: Gender
    let weather: Weather
}

struct Age: Codable, Hashable {
    let age: Int
    let writed: Bool
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

struct Gender: Codable, Hashable {
    let man, woman: Int
    let writed: Bool
}

struct SimilarPerfume: Codable, Hashable {
    let brandName, perfumeImgUrl, perfumeName: String
}

struct Weather: Codable, Hashable {
    let autumn, spring, summer, winter: Int
    let writed: Bool
}
