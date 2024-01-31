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
    case fetchSearchBrand
    case fetchHPediaTerm
    case fetchHPediaNote
    case fetchHPediaPerfumer
    case fetchHPediaBrand
    case fetchCommunity
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
        case .fetchSearchBrand:
            return "search/brand"
        case .fetchHPediaTerm:
            return "search/term"
        case .fetchHPediaNote:
            return "search/note"
        case .fetchHPediaPerfumer:
            return "search/perfumer"
        case .fetchHPediaBrand:
            return "search/brandStory"
        case .fetchCommunity:
            return "search/community"
        }
    }
}
