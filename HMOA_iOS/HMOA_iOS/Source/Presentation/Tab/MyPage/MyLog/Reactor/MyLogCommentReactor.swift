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
        case willDisplayCell(Int)
    }
    
    enum Mutation {
        case setPerfumeItem([Comment])
        case setCommunityItem([CommunityComment])
        case setCommentType(MyLogCommentSectionItem)
        case setLoadedPage(Int)
    }
    
    struct State {
        var perfumeItem: [Comment] = []
        var communityItem: [CommunityComment] = []
        var items: MyLogCommentData = MyLogCommentData(perfume: [], community: [])
        var commentType: MyLogCommentSectionItem
        var page: Int = 0
        var loadedPage: Set<Int> = []
        var navigationTitle: String
    }
    
    init(type: MyLogCommentSectionItem, title: String) {
        initialState = State(commentType: type, navigationTitle: title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            switch currentState.commentType {
            case .liked(_):
                return setLikedPerfumeComment(0, [])
            default: return setWritedPerfumeCommentList(0, [])
            }
            
        case .didTapPerfumeTab:
            return setWritedPerfumeCommentList(0, [])
            
        case .didTapCommunityTab:
            return setWritedCommunityCommentList(0, [])
            
        case .willDisplayCell(let page):
            switch currentState.commentType {
            case .perfume(_):
                return setWritedPerfumeCommentList(page, currentState.loadedPage)
            case .community(_):
                return setWritedCommunityCommentList(page, currentState.loadedPage)
            case .liked(_):
                return setLikedPerfumeComment(page, currentState.loadedPage)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPerfumeItem(let item):
            state.perfumeItem = item
            state.items.perfume = item
            
        case .setCommunityItem(let item):
            state.communityItem = item
            state.items.community = item
            
        case .setCommentType(let type):
            state.commentType = type
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
            
        }
        
        return state
    }
}

extension MyLogCommentReactor {
    func setWritedPerfumeCommentList(_ page: Int, _ loadedPage: Set<Int>) -> Observable<Mutation> {
        
        if loadedPage.contains(page) { return .empty() }
        
        return MemberAPI.fetchPerfumeComments(["page": page])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var item = self.currentState.perfumeItem
                item.append(contentsOf: data)
                
                return .concat([
                    .just(.setPerfumeItem(item)),
                    .just(.setCommunityItem([])),
                    .just(.setLoadedPage(page)),
                    .just(.setCommentType(.perfume(nil)))
                ])
            }
    }
    
    func setWritedCommunityCommentList(_ page: Int, _ loadedPage: Set<Int>) -> Observable<Mutation> {
        
        if loadedPage.contains(page) { return .empty() }
        
        return MemberAPI.fetchCommunityComments(["page": page])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                
                var item = self.currentState.communityItem
                item.append(contentsOf: data)
                
                return .concat([
                    .just(.setCommunityItem(item)),
                    .just(.setPerfumeItem([])),
                    .just(.setLoadedPage(page)),
                    .just(.setCommentType(.community(nil)))
                ])
            }
    }
    
    // TODO: - 오류 해결 시 작동 테스트
    func setLikedPerfumeComment(_ page: Int, _ loadedPage: Set<Int>) -> Observable<Mutation> {
        
        if loadedPage.contains(page) { return .empty() }
        return MemberAPI.fetchLikedComments(["page": page])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in

                var item = self.currentState.perfumeItem
                item.append(contentsOf: data)
                
                return .concat([
                    .just(.setPerfumeItem(item)),
                    .just(.setCommunityItem([])),
                    .just(.setLoadedPage(page))
                ])
            }
    }
}
