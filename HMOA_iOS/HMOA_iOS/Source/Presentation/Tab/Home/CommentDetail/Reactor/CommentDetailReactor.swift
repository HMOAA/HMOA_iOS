//
//  CommentDetailReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import ReactorKit
import RxSwift
import UIKit

class CommentDetailReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var comment: Comment
    }
    
    init() {
        self.initialState = State(comment: CommentDetailReactor.setCommentDetail())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {

    }
}

extension CommentDetailReactor {
    
    static func setCommentDetail() -> Comment {
        return Comment(commentId: 1, name: "안녕하세요", image: UIImage(named: "jomalon")!, likeCount: 150, content: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요", isLike: false)
    }
}
