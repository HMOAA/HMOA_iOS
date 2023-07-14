//
//  DetailSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import RxDataSources

enum DetailSection {
    case top(DetailSectionItem)
    case comment([DetailSectionItem])
    case recommend([DetailSectionItem])
}

enum DetailSectionItem {
    case topCell(PerfumeDetail, Int)
    case commentCell(Comment, Int)
    case recommendCell(RecommendPerfume, Int)
}

extension DetailSectionItem: Hashable {
    
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .topCell(let detail, let id):
            hasher.combine(detail)
            hasher.combine(id)
        case .commentCell(let comment, let id):
            hasher.combine(comment)
            hasher.combine(id)
        case .recommendCell(let recommend, let id):
            hasher.combine(recommend)
            hasher.combine(id)
        }
    }
    
    var id: Int {
        switch self {
        case .topCell:
            return 0
        case .commentCell(_, let commentId):
            return commentId
        case .recommendCell(_, let perfumeId):
            return perfumeId
        }
    }
    
    var section: Int {
        switch self {
        case .topCell:
            return 0
        case .commentCell:
            return 1
        case .recommendCell:
            return 2
        }
    }
}

extension DetailSection: Hashable {
    typealias Item = DetailSectionItem
    
    var items: [Item] {
        switch self {
        case .top(let items):
            return [items]
        case .comment(let items):
            return items
        case .recommend(let items):
            return items
        }
    }
}
