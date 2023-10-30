//
//  CommentListReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import RxSwift
import ReactorKit

class CommentListReactor: Reactor {
    
    let service: DetailCommentService
    
    enum Action {
        case viewDidLoad
        case willDisplayCell(Int)
        case didTapCell(IndexPath)
        case didTapWriteButton
        case didTapLikeSortButton
        case didTapRecentSortButton
        case didTapOptionButton(Int)
        case didDeleteComment
    }
    
    enum Mutation {
        case setSelectedComment(IndexPath?)
        case setIsPresentCommentWrite(Int?)
        case setCommentItem([Comment])
        case setSortType(String)
        case setCommentCount(Int)
        case setLoadedPage(Int)
        case setSelectedRow(Int?)
        case addComment(Comment)
        case editComment(Comment)
    }
    
    struct State {
        var commentItems: [Comment] = []
        var perfumeId: Int?
        var commentCount: Int = 0
        var selectedComment: Comment? = nil
        var isPresentCommentWriteVC: Int? = nil
        var sortType = ""
        var commentType: CommentType
        var navigationTitle: String
        var loadedPage: Set<Int> = []
        var selectedRow: Int? = nil
    }
    
    var initialState: State

    init(_ currentPerfumeId: Int?, _ type: CommentType, service: DetailCommentService) {
        initialState = State(
            perfumeId: currentPerfumeId,
            sortType: "Latest",
            commentType: type,
            navigationTitle: type.title
        )
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            switch currentState.commentType {
            case .detail:
                return setCommentsList(type: currentState.sortType, page: 0)
            case .liked:
                return setLikedCommentList()
            case .writed:
                return setWritedCommentList()
            }
            
        case .willDisplayCell(let page):
            switch currentState.commentType {
            case .detail:
                return setCommentsList(type: currentState.sortType, page: page)
            case .liked:
                return setLikedCommentList()
            case .writed:
                return setWritedCommentList()
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
            return setCommentsList(type: "Like", page: 0)
            
        case .didTapRecentSortButton:
            return setCommentsList(type: "Latest", page: 0)
            
        case .didTapOptionButton(let row):
            return .just(.setSelectedRow(row))
            
        case .didDeleteComment:
            return .empty()
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
            
            state.selectedComment = state.commentItems[indexPath.row]
            
        case .setIsPresentCommentWrite(let perfumeId):
            state.isPresentCommentWriteVC = perfumeId
            
        case .setCommentItem(let item):
            state.commentItems = item
            
        case .setSortType(let type):
            state.sortType = type
            
        case .setCommentCount(let count):
            state.commentCount = count
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
            
        case .setSelectedRow(let row):
            state.selectedRow = row
            
        case .addComment(let comment):
            state.commentItems.append(comment)
        case .editComment(let comment):
            if let index = state.commentItems.firstIndex(where: { $0.id == comment.id }) {
                state.commentItems[index] = comment
            }
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .addComment(let comment):
                return .just(.addComment(comment))
            case .editComment(let comment):
                return .just(.editComment(comment))
            }
        }
        return .merge(eventMutation, mutation)
    }
}

extension CommentListReactor {
    
    func setCommentsList(type: String, page: Int) -> Observable<Mutation> {
        guard let perfumeId = currentState.perfumeId else { return .empty() }
         
        if currentState.loadedPage.contains(page) { return .empty() }
        
        let parameter = [
            "page": page,
            "perfumeId": perfumeId
        ]
        
        return CommentAPI.fetchCommentList(parameter, type: type)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var items = self.currentState.commentItems
                let commentCount = data.commentCount
                items.append(contentsOf: data.comments)
                
                return .concat([
                    .just(.setCommentItem(items)),
                    .just(.setCommentCount(commentCount)),
                    .just(.setLoadedPage(page))
                ])
            }
    }
    
    func setLikedCommentList() -> Observable<Mutation> {
        return MemberAPI.fetchLikedComments(["page": 0])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setCommentItem(data))
            }
    }
    
    func setWritedCommentList() -> Observable<Mutation> {
        return MemberAPI.fetchWritedComments(["page": 0])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setCommentItem(data))
            }
    }
    
    func reactorForEdit() -> CommentWriteReactor {
        let state = currentState
        return CommentWriteReactor(
            perfumeId: state.perfumeId,
            isWrite: true,
            content: state.commentItems[state.selectedRow!].content,
            commentId: state.commentItems[state.selectedRow!].id,
            isCommunity: false,
            commentService: service)
    }
    
    func reactorForCommentAdd() -> CommentWriteReactor {
        return CommentWriteReactor(
            perfumeId: currentState.perfumeId,
            isWrite: false,
            content: "",
            commentId: nil,
            isCommunity: false,
            commentService: service)
    }
}
