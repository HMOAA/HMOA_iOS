//
//  CommentAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/02.
//

import Foundation

enum CommentAddress {
    case postCommnet(Int)
    case fetchCommentList(Int)
    case putCommentLike(Int)
    case deleteCommentLike(Int)
    case putComment(Int)
}

extension CommentAddress {
    var url: String {
        switch self {
        case .postCommnet(let perfumeId):
            return "perfume/\(perfumeId)/comments"
        case .fetchCommentList(let perfumeId):
            return "perfume/\(perfumeId)/comments/"
        case .putCommentLike(let commentId):
            return "perfume/comments\(commentId)/like"
        case .deleteCommentLike(let commentId):
            return "perfume/comments\(commentId)/like"
        case .putComment(let commentId):
            return "perfume/comments\(commentId)/modify"
        }
    }
}