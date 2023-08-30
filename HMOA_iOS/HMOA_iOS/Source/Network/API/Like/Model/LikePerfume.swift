//
//  LikePerfume.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/30.
//

import Foundation

struct LikePerfume: Decodable, Hashable {
    let likePerfumes: [Like]
    
    enum CodingKeys: String, CodingKey {
        case likePerfumes = "data"
    }
}

struct Like: Decodable, Hashable {
    let perfumeID: Int
    let brandName, koreanName, englishName: String
    let price: Int
    let perfumeImageUrl: String

    enum CodingKeys: String, CodingKey {
        case perfumeID = "perfumeId"
        case brandName,
             koreanName,
             englishName,
             price,
             perfumeImageUrl
    }
}
