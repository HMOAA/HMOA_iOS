//
//  CommentAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/02.
//

import Foundation

enum CommentAddress {
    case postCommnet(Int)
    case fetchCommentList(Int, String)
    case setCommentLike(Int)
    case putComment(Int)
    case modifyComment(Int)
}

extension CommentAddress {
    var url: String {
        switch self {
        case .postCommnet(let perfumeId):
            return "perfume/\(perfumeId)/comments"
        case .fetchCommentList(let perfumeId, let type):
            return "perfume/\(perfumeId)/comments/\(type)"
        case .setCommentLike(let commentId):
            return "perfume/comments/\(commentId)/like"
        case .putComment(let commentId):
            return "perfume/comments\(commentId)/modify"
        case .modifyComment(let perfumeId):
            return "perfume/comments/\(perfumeId)/modify"
        }
    }
}
