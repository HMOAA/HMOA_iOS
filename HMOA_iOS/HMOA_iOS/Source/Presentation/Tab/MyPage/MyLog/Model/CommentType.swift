//
//  CommentType.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/14.
//

import Foundation


enum CommentType {
    case detail
    case liked
    case writed
}

extension CommentType {
    var title: String {
        switch self {
        case .detail:
            return "댓글"
        case .liked:
            return "좋아요 누른 댓글"
        case .writed:
            return "작성한 댓글"
        }
    }
}
