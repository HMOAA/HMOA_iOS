//
//  DetailCommentService.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/30.
//

import Foundation

import RxSwift

enum DetailCommentEvent{
    case editComment(Comment)
    case addComment(Comment)
    case setCommentLike(Comment)
}

protocol DetailCommentServiceProtocol {
    var event: PublishSubject<DetailCommentEvent> { get }
    
    func addComment(to comment: Comment) -> Observable<Comment>
    func editComment(to comment: Comment) -> Observable<Comment>
    func setCommentLike(to comment: Comment) -> Observable<Comment>
}

class DetailCommentService: DetailCommentServiceProtocol {
    
    let event = PublishSubject<DetailCommentEvent>()
    
    func addComment(to comment: Comment) -> Observable<Comment> {
        event.onNext(.addComment(comment))
        return .just(comment)
    }
    
    func editComment(to comment: Comment) -> Observable<Comment> {
        event.onNext(.editComment(comment))
        return .just(comment)
    }
    
    func setCommentLike(to comment: Comment) -> Observable<Comment> {
        event.onNext(.setCommentLike(comment))
        return .just(comment)
    }
}
