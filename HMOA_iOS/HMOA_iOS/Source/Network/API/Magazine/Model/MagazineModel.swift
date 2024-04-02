//
//  MagazineModel.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/11/24.
//

import UIKit

struct Magazine: Hashable, Codable {
    let magazineID: Int
    let title: String
    let description: String
    let previewImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case magazineID = "magazineId"
        case title
        case description = "preview"
        case previewImageURL = "previewImgUrl"
    }
}

struct TopReview: Hashable, Codable {
    let id: Int
    let title: String
    let userName: String
    let content: String
}

struct NewPerfume: Hashable, Codable {
    let id: Int
    let name: String
    let brand: String
    let releaseDate: String
}

struct MagazineDetailResponse: Hashable, Codable {
    let magazineID: Int
    let title: String
    let releasedDate: String
    let previewImage: String
    let description: String
    let contents: [MagazineContent]
    let tags: [String]
    let viewCount: Int
    let likeCount: Int
    let liked: Bool
    
    enum CodingKeys: String, CodingKey {
        case magazineID = "magazineId"
        case title
        case releasedDate = "createAt"
        case description = "preview"
        case previewImage = "previewImgUrl"
        case contents
        case tags
        case viewCount
        case likeCount
        case liked
    }
}

struct MagazineInfo: Hashable, Codable {
    let title: String
    let releasedDate: String
    let viewCount: Int
    let previewImageURL: String
    let description: String
}

struct MagazineContent: Hashable, Codable {
    let type: String
    let data: String
}

struct MagazineTag: Hashable, Codable {
    let tag: String
}

struct MagazineLike: Hashable, Codable {
    let id: Int
    var isLiked: Bool
    var likeCount: Int
}
