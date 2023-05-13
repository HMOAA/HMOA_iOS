//
//  HomeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import UIKit
import RxDataSources

enum HomeSection {
    case homeTop([HomeSectionItem])
    case homeFirst(header: String, items: [HomeSectionItem])
    case homeSecond(header: String, items: [HomeSectionItem])
    case homeThrid(header: String, items: [HomeSectionItem])
    case homeFourth(header: String, items: [HomeSectionItem])
}

enum HomeSectionItem {
    case homeTopCell(String, Int)
    case homeFirstCell(HomeCellReactor, Int)
    case homeSecondCell(HomeCellReactor, Int)
    case homeThridCell(HomeCellReactor, Int)
    case homeFourthCell(HomeCellReactor, Int)
}

extension HomeSectionItem {
    
    var perfumeId: Int {
        switch self {
        case .homeTopCell(_, let perfumeId):
            return perfumeId
        case .homeFirstCell(_, let perfumeId):
            return perfumeId
        case .homeSecondCell(_, let perfumeId):
            return perfumeId
        case .homeThridCell(_, let perfumeId):
            return perfumeId
        case .homeFourthCell(_, let perfumeId):
            return perfumeId
        }
    }
}

extension HomeSection: SectionModelType {
    typealias Item = HomeSectionItem
    
    var items: [Item] {
        switch self {
        case .homeTop(let items):
            return items
        case .homeFirst(_, let items):
            return items
        case .homeSecond(_, let items):
            return items
        case .homeThrid(_, let items):
            return items
        case .homeFourth(_, let items):
            return items

        }
    }
    
    var headerTitle: String {
        switch self {
        case .homeTop(_):
            return ""
        case .homeFirst(let header, _):
            return header
        case .homeSecond(let header, _):
            return header
        case .homeThrid(let header, _):
            return header
        case .homeFourth(let header, _):
            return header
        }
    }
    
    init(original: HomeSection, items: [HomeSectionItem]) {
        self = original
    }
}
