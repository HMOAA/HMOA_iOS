//
//  CommentListReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import RxSwift
import ReactorKit
import RxDataSources

class CommentListReactor: Reactor {
    var currentPerfumeId: Int
    
    enum Action {
        case viewWillAppear
        case didTapCell(IndexPath)
        case didTapWriteButton
    }
    
    enum Mutation {
        case setSelectedCommentId(IndexPath?)
        case setIsPresentCommentWrite(Int?)
        case setCommentData
    }
    
    struct State {
        var comments: [CommentSection] = []
        var nowPerfumeId: Int? = nil
        var commentCount: Int = 0
        var presentCommentId: Int? = nil
        var isPresentCommentWriteVC: Int? = nil
    }
    
    var initialState: State = State()

    init(_ currentPerfumeId: Int) {
        self.currentPerfumeId = currentPerfumeId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.setCommentData)
            
        case .didTapCell(let indexPath):
            return .concat([
                .just(.setSelectedCommentId(indexPath)),
                .just(.setSelectedCommentId(nil))
            ])
            
        case .didTapWriteButton:
            return .concat([
                .just(.setIsPresentCommentWrite(currentPerfumeId)),
                .just(.setIsPresentCommentWrite(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setSelectedCommentId(let indexPath):
            guard let indexPath = indexPath else {
                state.presentCommentId = nil
                return state
            }
            
            state.presentCommentId = state.comments[indexPath.section].items[indexPath.row].commentId
            
        case .setIsPresentCommentWrite(let perfumeId):
            state.isPresentCommentWriteVC = perfumeId
            
        case .setCommentData:
            let data = CommentListReactor.setCommentsList(currentPerfumeId)
            state.comments = data.0
            state.commentCount = data.1
            
        }
        return state
    }
}

extension CommentListReactor {
    static func setCommentsList(_ id: Int) -> ([CommentSection], Int) {
        
        print(id)
        // TODO: currentPerfumeId로 서버 통신해서 댓글 가져오기
        
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
        
        let commentItems = comments.map {CommentSectionItem.commentCell(CommentCellReactor(comment: $0), $0.commentId)}
        
        let commentSection = CommentSection.comment(commentItems)
        
        let count = 100
        return ([commentSection], count)
    }
}
