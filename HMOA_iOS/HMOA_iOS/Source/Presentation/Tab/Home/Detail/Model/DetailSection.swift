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
    case evaluation(DetailSectionItem)
    case comment([DetailSectionItem])
    case similar([DetailSectionItem])
}

enum DetailSectionItem {
    case topCell(FirstDetail, Int)
    case evaluationCell(Evaluation?, Int)
    case commentCell(Comment?, Int)
    case similarCell(SimilarPerfume, Int)
}

extension DetailSectionItem: Hashable {
    
    var id: Int {
        switch self {
        case .topCell:
            return 0
        case .evaluationCell:
            return 1
        case .commentCell(_, let commentId):
            return commentId
        case .similarCell(_, let perfumeId):
            return perfumeId
        }
    }
    
    var section: Int {
        switch self {
        case .topCell:
            return 0
        case .evaluationCell:
            return 1
        case .commentCell:
            return 2
        case .similarCell:
            return 3
        }
    }
    
    var brandId: Int {
        switch self {
        case .topCell(let data, _):
            return data.perfumeDetail.brandId
        default: return 0
        }
    }
}

extension DetailSection: Hashable {
    typealias Item = DetailSectionItem
    
    var items: [Item] {
        switch self {
        case .top(let items):
            return [items]
        case .evaluation(let items):
            return [items]
        case .comment(let items):
            return items
        case .similar(let items):
            return items
        }
    }
}
