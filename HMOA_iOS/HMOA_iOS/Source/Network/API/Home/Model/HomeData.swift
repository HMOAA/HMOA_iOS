//
//  HomeData.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/13.
//

import Foundation

struct HomeFirstData: Codable {
    let mainImage: String
    let recommend: RecommendPerfumeList
}

struct RecommendPerfumeList: Codable {
    let title: String
    let perfumeList: [RecommendPerfume]
}

struct RecommendPerfume: Codable {
    let id: Int
    let brandName: String
    let perfumeName: String
    let imageUrl: String
}


struct HomeSecondData: Codable {
    let recommend: [RecommendPerfumeList]
    
    enum CodingKeys: String, CodingKey {
        case recommend = "data"
    }
    
}


