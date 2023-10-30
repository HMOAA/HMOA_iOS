//
//  CommentReactorType.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/30.
//

import Foundation

import ReactorKit

enum CommentReactorType {
    case community(QnADetailReactor)
    case perfumeDetail(DetailViewReactor)
    case commentList(CommentListReactor)
    
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
