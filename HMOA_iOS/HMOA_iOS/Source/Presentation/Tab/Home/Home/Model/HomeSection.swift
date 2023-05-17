//
//  HomeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import UIKit
import RxDataSources

enum HomeSection {
    case topSection([HomeSectionItem])
    case recommendSection(header: String, items: [HomeSectionItem])

}

enum HomeSectionItem {
    case topCell(String, Int)
    case recommendCell(HomeCellReactor, Int)
}

extension HomeSectionItem {
    
    var perfumeId: Int {
        switch self {
        case .topCell(_, let perfumeId):
            return perfumeId
        case .recommendCell(_, let perfumeId):
            return perfumeId
        }
    }
}

extension HomeSection: SectionModelType {
    typealias Item = HomeSectionItem
    
    var items: [Item] {
        switch self {
        case .topSection(let items):
            return items
        case .recommendSection(_, let items):
            return items
        }
    }
    
    var headerTitle: String {
        switch self {
        case .topSection(_):
            return ""
        case .recommendSection(let header, _):
            return header
        }
    }
    
    init(original: HomeSection, items: [HomeSectionItem]) {
        self = original
    }
}
