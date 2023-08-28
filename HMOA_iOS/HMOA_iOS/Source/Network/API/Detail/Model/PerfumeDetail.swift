//
//  PerfumeDetail.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit

struct PerfumeDetail: Hashable, Decodable{
    let perfumeDetail: Detail
    
    enum CodingKeys: String, CodingKey {
        case perfumeDetail = "data"
    }
}

struct Detail: Hashable, Decodable {
    let perfumeID: Int
    let brandName, koreanName, englishName: String
    let price: Int
    let volume: [Int]
    let priceVolume: Int
    let topNote, heartNote, baseNote: String
    let brandEnglishName: String
    let brandImgUrl: String
    let singleNote: String?

    enum CodingKeys: String, CodingKey {
        case perfumeID = "perfumeId"
        case brandName,
             koreanName,
             englishName,
             price,
             volume,
             priceVolume,
             topNote,
             heartNote,
             baseNote,
             brandEnglishName,
             brandImgUrl,
             singleNote
    }
}
