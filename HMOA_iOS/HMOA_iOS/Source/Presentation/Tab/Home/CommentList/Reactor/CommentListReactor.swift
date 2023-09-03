//
//  CommentListReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import RxSwift
import ReactorKit

class CommentListReactor: Reactor {
    
    enum Action {
        case viewWillAppear
        case didTapCell(IndexPath)
        case didTapWriteButton
        case didTapLikeSortButton
        case didTapRecentSortButton
    }
    
    enum Mutation {
        case setSelectedCommentId(IndexPath?)
        case setIsPresentCommentWrite(Int?)
        case setCommentSection([CommentSection])
        case setSortType(String)
    }
    
    struct State {
        var commentSections: [CommentSection] = []
        var perfumeId: Int?
        var commentCount: Int = 0
        var presentCommentId: Int? = nil
        var isPresentCommentWriteVC: Int? = nil
        var sortType = ""
    }
    
    var initialState: State

    init(_ currentPerfumeId: Int) {
        initialState = State(
            perfumeId: currentPerfumeId,
            sortType: "Latest"
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return setCommentsList(type: currentState.sortType)
            
        case .didTapCell(let indexPath):
            return .concat([
                .just(.setSelectedCommentId(indexPath)),
                .just(.setSelectedCommentId(nil))
            ])
            
        case .didTapWriteButton:
            return .concat([
                .just(.setIsPresentCommentWrite(currentState.perfumeId)),
                .just(.setIsPresentCommentWrite(nil))
            ])
        
        case .didTapLikeSortButton:
            return .just(.setSortType("Like"))
            
        case .didTapRecentSortButton:
            return .just(.setSortType("Latest"))
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
            
            state.presentCommentId = state.commentSections[indexPath.section].items[indexPath.row].commentId
            
        case .setIsPresentCommentWrite(let perfumeId):
            state.isPresentCommentWriteVC = perfumeId
            
        case .setCommentSection(let section):
            state.commentSections = section
            
        case .setSortType(let type):
            state.sortType = type
        }
        
        return state
    }
}

extension CommentListReactor {
    
    func setCommentsList(type: String) -> Observable<Mutation> {
        
        guard let perfumeId = currentState.perfumeId else { return .empty() }
        
        let parameter = [
            "page": 0,
            "perfumeId": perfumeId
        ]
        
        return CommentAPI.fetchCommentList(parameter, type: type)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let commentItems = data.comments.map { CommentSectionItem.commentCell($0, $0.id) }
                let commentSection = [CommentSection.comment(commentItems)]
                
                return .just(.setCommentSection(commentSection))
            }
    }
}
