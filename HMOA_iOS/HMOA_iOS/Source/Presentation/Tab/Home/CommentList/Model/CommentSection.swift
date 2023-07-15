//
//  CommentSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import RxDataSources

enum CommentSection: Hashable {
    case comment([CommentSectionItem])
}

enum CommentSectionItem {
    case commentCell(Comment, Int)
}

extension CommentSectionItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .commentCell(let comment, let id):
            hasher.combine(comment)
            hasher.combine(id)
        }
    }
    var commentId: Int {
        switch self {
        case .commentCell(_, let commentId):
            return commentId
        }
    }
}

extension CommentSection {
    typealias Item = CommentSectionItem
    
    var items: [Item] {
        switch self {
        case .comment(let items):
            return items
        }
    }
}
