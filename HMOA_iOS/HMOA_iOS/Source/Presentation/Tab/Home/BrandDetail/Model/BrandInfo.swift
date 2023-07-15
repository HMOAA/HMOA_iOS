//
//  BrandInfo.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import Foundation

struct BrandInfo: Equatable, Hashable {
    var brandId: Int
    var koreanName: String
    var EnglishName: String
    var isLikeBrand: Bool
}
