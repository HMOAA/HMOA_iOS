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
    case topCell(FirstDetail)
    case evaluationCell(Evaluation?)
    case commentCell(Comment?)
    case similarCell(SimilarPerfume)
}

extension DetailSectionItem: Hashable {
    
    var id: Int? {
        switch self {
        case .commentCell(let comment):
            return comment?.id
        case .similarCell(let perfume):
            return perfume.perfumeId
        default: return nil
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
        case .topCell(let data):
            return data.brandId
        default: return 0
        }
    }
    
    var comment: Comment? {
        switch self {
        case .commentCell(let comment):
            return comment
        default: return nil
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
