//
//  SearchAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/07/15.
//

import Foundation

enum SearchAddress {
    case getPerfumeName
    case getPerfumeInfo
    case fetchBrandAll
}

extension SearchAddress {
    var url: String {
        switch self {
        case .getPerfumeName:
            return "search/perfumeName"
        case .getPerfumeInfo:
            return "search/perfume"
        case .fetchBrandAll:
            return "search/brandAll"
        }
    }
}
