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
        case viewDidLoad(Bool)
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
        case setIsLogin(Bool)
        case setIsTapWhenNotLogin(Bool)
    }
    
    struct State {
        var commentItems: [Comment] = []
        var perfumeId: Int?
        var commentCount: Int = 0
        var selectedComment: Comment? = nil
        var isPresentCommentWriteVC: Int? = nil
        var sortType = ""
        var navigationTitle: String = "댓글"
        var loadedPage: Set<Int> = []
        var selectedRow: Int? = nil
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
    }
    
    var initialState: State

    init(_ currentPerfumeId: Int?, service: DetailCommentService) {
        initialState = State(
            perfumeId: currentPerfumeId,
            sortType: "Latest"
        )
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let isLogin):
            return .concat([
                .just(.setIsLogin(isLogin)),
                setCommentsList(type: currentState.sortType, page: 0)
                ])
            
        case .willDisplayCell(let page):
            return setCommentsList(type: currentState.sortType, page: page)
            
        
        case .didTapCell(let indexPath):
            return .concat([
                .just(.setSelectedComment(indexPath)),
                .just(.setSelectedComment(nil))
            ])
            
        case .didTapWriteButton:
            if currentState.isLogin {
                return .concat([
                    .just(.setIsPresentCommentWrite(currentState.perfumeId)),
                    .just(.setIsPresentCommentWrite(nil))
                ])
            } else {
                return .concat([
                    .just(.setIsTapWhenNotLogin(true)),
                    .just(.setIsTapWhenNotLogin(false))
                ])
            }
        
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
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
            
        case .setIsTapWhenNotLogin(let isTap):
            state.isTapWhenNotLogin = isTap
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
    
    func deleteCommentInSection() -> Observable<Mutation> {
        guard let row = currentState.selectedRow else { return .empty() }
        var commentItem = currentState.commentItems
        commentItem.remove(at: row)

        return .concat([
            .just(.setCommentItem(commentItem)),
            .just(.setSelectedRow(nil)),
            .just(.setCommentCount(currentState.commentCount - 1))
        ])
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
