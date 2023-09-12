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


struct Age: Codable, Hashable {
    let age: Int
    let writed: Bool
}


struct CommentInfo: Codable, Hashable {
    let commentCount: Int
    let comments: [DetailComent]
}


struct DetailComent: Codable, Hashable {
    let content, createAt: String
    let heartCount, id: Int
    let liked: Bool
    let nickname: String
    let perfumeId: Int
    let profileImg: String
    let writed: Bool
}

struct Gender: Codable, Hashable {
    let man, woman: Int
    let writed: Bool
}

struct SimilarPerfume: Codable, Hashable {
    let brandName, perfumeImgURL, perfumeName: String
}

struct Weather: Codable, Hashable {
    let autumn, spring, summer, winter: Int
    let writed: Bool
}
