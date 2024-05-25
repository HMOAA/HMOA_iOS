//
//  PerfumeDetail.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit

struct FirstDetail: Hashable, Codable{
    let perfumeId, heartNum, brandId: Int
    let brandName, brandEnglishName: String
    let brandImgUrl: String
    let koreanName: String
    let englishName: String?
    let perfumeImageUrl: String
    let price: Int
    let volume: [Int]
    let priceVolume: Int
    let topNote, heartNote, baseNote: String?
    let notePhotos: [Int]
    let sortType: Int
    let evaluation: Evaluation
    let liked: Bool
    
    enum CodingKeys: String, CodingKey {
        case evaluation = "review"
        case perfumeId, heartNum, brandId
        case brandName, brandEnglishName, brandImgUrl
        case notePhotos
        case koreanName, englishName, perfumeImageUrl
        case price, volume, priceVolume
        case topNote, heartNote, baseNote
        case sortType, liked
    }
    
}


struct Evaluation: Codable, Hashable {
    let age: Age
    let gender: Gender
    let weather: Weather
}

struct Age: Codable, Hashable {
    let age: Int
    let writed: Bool
}

struct Gender: Codable, Hashable {
    let man, woman, neuter: Int
    let writed: Bool
    let selected: Int
}


struct Weather: Codable, Hashable {
    let autumn, spring, summer, winter: Int
    let writed: Bool
    let selected: Int
}
