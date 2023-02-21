//
//  CommendListReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import RxSwift
import ReactorKit
import RxDataSources

class CommendListReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didTapCell(IndexPath)
    }
    
    enum Mutation {
        case setCommentCount
        case setSelectedCommentId(IndexPath?)
    }
    
    struct State {
        var comments: [CommentSection]
        var commentCount: Int = 0
        var presentCommentId: Int? = nil
    }
    
    init() {
        self.initialState = State(comments: CommendListReactor.setCommentsList())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setCommentCount)
        case .didTapCell(let indexPath):

            return .concat([
                .just(.setSelectedCommentId(indexPath)),
                .just(.setSelectedCommentId(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setCommentCount:
            // TODO: 서버 통신해서 댓글 Count 값 가져오기
            state.commentCount = 100
        case .setSelectedCommentId(let indexPath):
            
            guard let indexPath = indexPath else {
                state.presentCommentId = nil
                return state
            }
            
            state.presentCommentId = state.comments[indexPath.section].items[indexPath.row].commentId
        }
        return state
    }
}

extension CommendListReactor {
    static func setCommentsList() -> [CommentSection] {
        
        // TODO: 서버 통신해서 댓글 가져오기
        
        let comments = [
            Comment(commentId: 1, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 2, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 3, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 4, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 5, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 6, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 7, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 8, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 9, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 10, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 11, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 12, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false)
        ]
        
        let commentItems = comments.map {CommentSectionItem.commentCell(CommentReactor(comment: $0), $0.commentId)}
        
        let commentSection = CommentSection.comment(commentItems)
        
        return [commentSection]
    }
}
