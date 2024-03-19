//
//  MagazineModel.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/11/24.
//

import UIKit

// Magazine
struct Magazine: Hashable, Codable {
    let id: Int
    let slogan: String
    let perfumeName: String
    let description: String
    let longDescription: String
    let releaseDate: String
    let content: String
    let liked: Bool
    let likeCount: Int
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

// MagazineDetail

struct MagazineDetail: Hashable, Codable {
    let title: String
    let releasedDate: String
    let contents: [MagazineContent]
    let tags: [String]
    let viewCount: Int
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case releasedDate = "createdAt"
        case contents
        case tags
        case viewCount
        case likeCount
    }
    
    struct MagazineContent: Hashable, Codable {
        let type: String
        let data: String
    }
}
