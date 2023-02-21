//
//  CommentSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import RxDataSources

enum CommentSection {
    case comment([CommentSectionItem])
}

enum CommentSectionItem {
    case commentCell(CommentReactor, Int)
}

extension CommentSectionItem {
    
    var commentId: Int {
        switch self {
        case .commentCell(_, let commentId):
            return commentId
        }
    }
}

extension CommentSection: SectionModelType {
    typealias Item = CommentSectionItem
    
    var items: [Item] {
        switch self {
        case .comment(let items):
            return items
        }
    }
    
    init(original: CommentSection, items: [CommentSectionItem]) {
        switch original {
        case .comment:
            self = .comment(items)
        }
    }
}
