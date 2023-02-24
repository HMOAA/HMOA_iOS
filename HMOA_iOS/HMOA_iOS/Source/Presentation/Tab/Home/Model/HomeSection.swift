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
    case homeFirst([HomeSectionItem])
    case homeSecond([HomeSectionItem])
    case homeWatch([HomeSectionItem])
}

enum HomeSectionItem {
    case homeTopCell(UIImage?, Int)
    case homeFirstCell(HomeCellReactor, Int)
    case homeSecondCell(HomeCellReactor, Int)
    case homeWatchCell(HomeCellReactor, Int)
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
        case .homeWatchCell(_, let perfumeId):
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
        case .homeFirst(let items):
            return items
        case .homeSecond(let items):
            return items
        case .homeWatch(let items):
            return items

        }
    }
    
    init(original: HomeSection, items: [HomeSectionItem]) {
        switch original {
        case .homeTop:
            self = .homeTop(items)
        case .homeFirst:
            self = .homeFirst(items)
        case .homeSecond:
            self = .homeSecond(items)
        case .homeWatch:
            self = .homeWatch(items)
        }
    }
}

