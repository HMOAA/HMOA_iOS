//
//  MyLogCommentReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/20/23.
//

import Foundation

import ReactorKit
import RxSwift

class MyLogCommentReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didTapPerfumeTab
        case didTapCommunityTab
        case prefetchItems(Int)
        case didSelectedCell(Int)
    }
    
    enum Mutation {
        case setPerfumeItem([MyLogComment])
        case setCommunityItem([MyLogComment])
        case setCurrentPerfumePage(Int)
        case setCurrentCommunityPage(Int)
        case setPerfumeId(Int?)
        case setCommunityId(Int?)
        case setIsPerfume(Bool)
    }
    
    struct State {
        var perfumeItem: [MyLogComment] = []
        var communityItem: [MyLogComment] = []
        var items: [MyLogComment] {
            if isPerfume {
                return perfumeItem
            } else {
                return communityItem
            }
        }
        var commentType: MyLogCommentType
        var currentPerfumePage: Int = -1
        var currentCommunityPage: Int = -1
        var navigationTitle: String
        var perfumeId: Int? = nil
        var communityId: Int? = nil
        var selectedRow: Int? = nil
        var isPerfume: Bool = true
    }
    
    init(type: MyLogCommentType, title: String) {
        initialState = State(commentType: type, navigationTitle: title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                setLikedPerfumeCommentList(currentPage: -1, items: [], row: 0),
                setLikedCommunityCommentList(currentPage: -1, items: [], row: 0)
            )
            
        case .didTapPerfumeTab:
            return .just(.setIsPerfume(true))
            
        case .didTapCommunityTab:
            return .just(.setIsPerfume(false))
            
        case .prefetchItems(let row):
            switch currentState.commentType {
            case .liked:
                if currentState.isPerfume {
                    return setLikedPerfumeCommentList(
                        currentPage: currentState.currentPerfumePage,
                        items: currentState.perfumeItem,
                        row: row
                    )
                } else {
                    return setLikedCommunityCommentList(
                        currentPage: currentState.currentCommunityPage,
                        items: currentState.communityItem,
                        row: row
                    )
                }
            case .writed:
                if currentState.isPerfume {
                    return setWritedPerfumeCommentList(
                        currentPage: currentState.currentPerfumePage,
                        items: currentState.perfumeItem,
                        row: row
                    )
                } else {
                    return setWritedCommunityCommentList(
                        currentPage: currentState.currentCommunityPage,
                        items: currentState.communityItem,
                        row: row
                    )
                }
            }
            
        case .didSelectedCell(let row):
            if currentState.isPerfume {
                return .concat([
                    .just(.setPerfumeId(currentState.perfumeItem[row].parentId)),
                    .just(.setPerfumeId(nil))
                ])
            } else {
                return .concat([
                    .just(.setCommunityId(currentState.communityItem[row].parentId)),
                    .just(.setCommunityId(nil))
                ])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPerfumeItem(let item):
            state.perfumeItem = item
            
        case .setCommunityItem(let item):
            state.communityItem = item
            
        case .setCurrentPerfumePage(let page):
            state.currentPerfumePage = page
            
        case .setCurrentCommunityPage(let page):
            state.currentCommunityPage = page
            
        case .setPerfumeId(let id):
            state.perfumeId = id
            
        case .setCommunityId(let id):
            state.communityId = id
            
        case .setIsPerfume(let isPerfume):
            state.isPerfume = isPerfume
        }
        return state
    }
}

extension MyLogCommentReactor {
    func setWritedPerfumeCommentList(currentPage: Int, items: [MyLogComment], row: Int) -> Observable<Mutation> {
        if items.count - 1 == row || currentPage == -1 {
            let newPage = currentPage + 1
            return MemberAPI.fetchPerfumeComments(["page": newPage])
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var item = self.currentState.perfumeItem
                    item.append(contentsOf: data)
                    
                    return .concat([
                        .just(.setPerfumeItem(item)),
                        .just(.setCurrentPerfumePage(newPage))
                    ])
                }
        } else { return .empty() }
    }
        
    func setWritedCommunityCommentList(currentPage: Int, items: [MyLogComment], row: Int) -> Observable<Mutation> {
        if items.count - 1 == row || currentPage == -1 {
            let newPage = currentPage + 1
            
            return MemberAPI.fetchCommunityComments(["page": newPage])
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var item = self.currentState.communityItem
                    item.append(contentsOf: data)
                    
                    return .concat([
                        .just(.setCommunityItem(item)),
                        .just(.setCurrentCommunityPage(newPage))
                    ])
                }
        } else { return .empty() }
    }
    
    func setLikedPerfumeCommentList(currentPage: Int, items: [MyLogComment], row: Int) -> Observable<Mutation> {
        if items.count - 1 == row || currentPage == -1 {
            let newPage = currentPage + 1
            return MemberAPI.fetchLikedPerfumeComments(["page": newPage])
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var item = items
                    item.append(contentsOf: data)
                    return .concat([
                        .just(.setPerfumeItem(item)),
                        .just(.setCurrentPerfumePage(newPage))
                    ])
                }
        } else { return .empty() }
    }
    
    func setLikedCommunityCommentList(currentPage: Int, items: [MyLogComment], row: Int) -> Observable<Mutation> {
        if items.count - 1 == row || currentPage == -1 {
            let newPage = currentPage + 1
            return MemberAPI.fetchLikedCommunityComments(["page": newPage])
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var item = items
                    item.append(contentsOf: data)
                    
                    return .concat([
                        .just(.setCommunityItem(item)),
                        .just(.setCurrentCommunityPage(newPage))
                    ])
                }
        } else { return .empty() }
    }
}
