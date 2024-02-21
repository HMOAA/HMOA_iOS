//
//  CommentReactorType.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/30.
//

import Foundation

import ReactorKit

enum CommentReactorType {
    case community(CommunityDetailReactor)
    case perfumeDetail(DetailViewReactor)
    case commentList(CommentListReactor)
    
}

enum OptionType {
    case Post(OptionPostData)
    case Comment(OptionCommentData)
}
    
struct OptionPostData {
    let id: Int
    let content: String
    let title: String
    let category: String
    let isWrited: Bool
}

struct OptionCommentData {
    let id: Int
    let content: String
    let isWrited: Bool
    let isCommunity: Bool
}

extension CommentReactorType {
    var reactor: any Reactor {
        switch self {
        case .commentList(let reactor):
            return reactor
        case .community(let reactor):
            return reactor
        case .perfumeDetail(let reactor):
            return reactor
        }
    }
}
