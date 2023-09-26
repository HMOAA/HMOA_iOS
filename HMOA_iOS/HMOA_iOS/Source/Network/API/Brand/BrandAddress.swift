//
//  BrandAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/25.
//

import Foundation

enum BrandAdress {
    case fetchBrandInfomation(String)
    case fetchPerfumeListByBrand(String, String)
}

extension BrandAdress {
    var url: String {
        switch self {
        case .fetchBrandInfomation(let id):
            return "brand/\(id)"
        case .fetchPerfumeListByBrand(let id, let type):
            return "brand/perfumes/\(id)/\(type)"
        }
    }
}
