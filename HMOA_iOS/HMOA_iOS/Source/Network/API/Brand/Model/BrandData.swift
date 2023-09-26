//
//  BrandDAta.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/25.
//

import Foundation

struct BrandResponse: Hashable, Codable {
    let data: Brand
}

struct BrandPerfumeResponse: Hashable, Codable {
    let data: [BrandPerfume]
}

struct BrandPerfume: Hashable, Codable {
    let brandName: String
    let perfumeId: Int
    let perfumeImgUrl: String
    let perfumeName: String
    let liked: Bool
}
