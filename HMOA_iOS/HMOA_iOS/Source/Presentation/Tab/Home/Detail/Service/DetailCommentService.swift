//
//  DetailCommentService.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/30.
//

import Foundation

import RxSwift

enum DetailCommentEvent{
    case updateComment(Comment)
    case addComment(Comment)
    case deleteComment(Int)
}

protocol DetailCommentServiceProtocol {
    var event: PublishSubject<DetailCommentEvent> { get }
    
    func addComment(to comment: Comment) -> Observable<Comment>
    func updateComment(to comment: Comment) -> Observable<Comment>
    func deleteComment(to id: Int) -> Observable<Int>
}

class DetailCommentService: DetailCommentServiceProtocol {
    
    let event = PublishSubject<DetailCommentEvent>()
    
    func addComment(to comment: Comment) -> Observable<Comment> {
        event.onNext(.addComment(comment))
        return .just(comment)
    }
    
    func updateComment(to comment: Comment) -> Observable<Comment> {
        event.onNext(.updateComment(comment))
        return .just(comment)
    }
    
    func deleteComment(to id: Int) -> Observable<Int> {
        event.onNext(.deleteComment(id))
        return .just(id)
    }
}
