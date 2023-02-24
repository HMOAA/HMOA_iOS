//
//  PerfumeDetail.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit

struct PerfumeDetail:  Equatable {
    let perfumeId: Int
    let perfumeImage: UIImage
    let likeCount: Int
    let koreanName: String
    let englishName: String
    let category: [String]
    let price: Int
    let volume: [Int]
    let age: Int
    let gender: String
    let BrandImage: UIImage
    let productInfo: String
    let topTasting: String
    let heartTasting: String
    let baseTasting: String
    let isLikePerfume: Bool
    let isLikeBrand: Bool
}
