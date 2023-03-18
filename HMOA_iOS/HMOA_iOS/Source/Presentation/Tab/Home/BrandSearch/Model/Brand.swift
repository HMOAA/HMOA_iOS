//
//  Brand.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

struct BrandList: Equatable {
    var consonant: String
    var brands: [Brand]
}

struct Brand: Equatable {
    var brandId: Int
    var brandName: String
}
