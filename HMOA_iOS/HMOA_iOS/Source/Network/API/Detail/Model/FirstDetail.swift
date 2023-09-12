//
//  PerfumeDetail.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit

struct FirstDetail: Hashable, Decodable{
    let perfumeDetail: Detail
    
    enum CodingKeys: String, CodingKey {
        case perfumeDetail = "data"
    }
}

struct Detail: Hashable, Decodable {
    let perfumeId: Int
    var heartNum: Int
    let brandId: Int
    let brandName, brandEnglishName: String
    let brandImgUrl: String
    let koreanName, englishNAme: String
    let perfumeImageUrl: String
    let price: Int
    let volume: [Int]
    let priceVolume: Int
    let topNote, heartNote, baseNote: String
    let singleNote: String?
    let sortType: Int
    var liked: Bool
}
