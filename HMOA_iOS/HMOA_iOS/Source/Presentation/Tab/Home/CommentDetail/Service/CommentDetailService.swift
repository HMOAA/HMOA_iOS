//
//  CommentDetailService.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/25.
//

import Foundation
import RxSwift

enum UserCommentEvent {
    case updateContent(String)
}


protocol UserCommentServiceProtocol {
    var event: PublishSubject<UserCommentEvent> { get }
    func updateContent(to name: String) -> Observable<String>
}

class UserCommentService: UserCommentServiceProtocol {
    let event = PublishSubject<UserCommentEvent>()
    
    func updateContent(to name: String) -> Observable<String> {
        
        event.onNext(.updateContent(name))
        return .just(name)
    }
}
