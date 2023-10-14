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
        case setSelectedComment(IndexPath?)
        case setIsPresentCommentWrite(Int?)
        case setCommentSection([CommentSection])
        case setSortType(String)
        case setCommentCount(Int)
    }
    
    struct State {
        var commentSections: [CommentSection] = []
        var perfumeId: Int?
        var commentCount: Int = 0
        var selectedComment: Comment? = nil
        var isPresentCommentWriteVC: Int? = nil
        var sortType = ""
        var commentType: CommentType
        var navigationTitle: String
    }
    
    var initialState: State

    init(_ currentPerfumeId: Int?, _ type: CommentType) {
        initialState = State(
            perfumeId: currentPerfumeId,
            sortType: "Latest",
            commentType: type,
            navigationTitle: type.title
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            switch currentState.commentType {
            case .detail:
                return setCommentsList(type: currentState.sortType)
            case .liked:
                return .empty()
            case .writed:
                return .empty()
            }
            
        case .didTapCell(let indexPath):
            return .concat([
                .just(.setSelectedComment(indexPath)),
                .just(.setSelectedComment(nil))
            ])
            
        case .didTapWriteButton:
            return .concat([
                .just(.setIsPresentCommentWrite(currentState.perfumeId)),
                .just(.setIsPresentCommentWrite(nil))
            ])
        
        case .didTapLikeSortButton:
            return setCommentsList(type: "Like")
            
        case .didTapRecentSortButton:
            return setCommentsList(type: "Latest")
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setSelectedComment(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedComment = nil
                return state
            }
            
            state.selectedComment = state.commentSections[indexPath.section].items[indexPath.row].commentCell
            
        case .setIsPresentCommentWrite(let perfumeId):
            state.isPresentCommentWriteVC = perfumeId
            
        case .setCommentSection(let section):
            state.commentSections = section
            
        case .setSortType(let type):
            state.sortType = type
            
        case .setCommentCount(let count):
            state.commentCount = count
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
                let commentCount = data.commentCount
                let commentSection = [CommentSection.comment(commentItems)]
                
                return .concat([
                    .just(.setCommentSection(commentSection)),
                    .just(.setCommentCount(commentCount))
                ])
            }
    }
}
