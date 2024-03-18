//
//  HomeData.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/13.
//

import Foundation

struct HomeFirstData: Codable, Hashable {
    let mainImage: String
    let banner: String
    let firstMenu: RecommendPerfumeList
}

struct RecommendPerfumeList: Codable, Hashable {
    let title: String
    let perfumeList: [RecommendPerfume]
}

struct RecommendPerfume: Codable, Hashable{
    let perfumeId: Int
    let brandName: String
    let perfumeName: String
    let imgUrl: String
}


typealias HomeSecondData = [RecommendPerfumeList]
