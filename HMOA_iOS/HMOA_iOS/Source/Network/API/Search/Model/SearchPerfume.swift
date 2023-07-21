//
//  PerfumeSearch.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/07/15.
//

import Foundation

struct SearchPerfumeName: Codable {
    let perfumeName: String
}

struct SearchPerfume: Codable, Equatable {
    let brandName: String
    let isHeart: Bool
    let perfumeId: Int
    let perfumeImageUrl: String
    let perfumeName: String
    
    enum CodingKeys: String, CodingKey {
        case brandName
        case isHeart = "heart"
        case perfumeId
        case perfumeImageUrl
        case perfumeName
    }
}
