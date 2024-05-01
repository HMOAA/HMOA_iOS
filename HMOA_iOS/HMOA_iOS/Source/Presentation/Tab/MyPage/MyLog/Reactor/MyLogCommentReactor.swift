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
        case didSelectedCell(Int)
    }
    
    enum Mutation {
        case setPerfumeItem([MyLogComment])
        case setCommunityItem([MyLogComment])
        case setCommentType(MyLogCommentSectionItem)
        case setLoadedPage(Set<Int>)
        case setPerfumeId(Int?)
        case setCommunityId(Int?)
    }
    
    struct State {
        var perfumeItem: [MyLogComment] = []
        var communityItem: [MyLogComment] = []
        var items: MyLogCommentData = MyLogCommentData(perfume: [], community: [])
        var commentType: MyLogCommentSectionItem
        var page: Int = 0
        var loadedPage: Set<Int> = []
        var navigationTitle: String
        var perfumeId: Int? = nil
        var communityId: Int? = nil
        var selectedRow: Int? = nil
    }
    
    init(type: MyLogCommentSectionItem, title: String) {
        initialState = State(commentType: type, navigationTitle: title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            switch currentState.commentType {
            case .liked:
                return setLikedPerfumeCommentList(0, [])
            default:
                return setWritedPerfumeCommentList(0, [])
            }
            
        case .didTapPerfumeTab:
            switch currentState.commentType {
            case .liked:
                return setLikedPerfumeCommentList(0, [])
            case .perfume:
                return setWritedPerfumeCommentList(0, [])
            default:
                return .empty()
            }
            
        case .didTapCommunityTab:
            switch currentState.commentType {
            case .liked:
                return setLikedCommunityCommentList(0, [])
            case .perfume:
                return setWritedCommunityCommentList(0, [])
            default:
                return .empty()
            }
            
        case .willDisplayCell(let page):
            switch currentState.commentType {
            case .perfume(_):
                return setWritedPerfumeCommentList(page, currentState.loadedPage)
            case .community(_):
                return setWritedCommunityCommentList(page, currentState.loadedPage)
            case .liked(_):
                if currentState.communityItem.isEmpty {
                    return setLikedPerfumeCommentList(page, currentState.loadedPage)
                } else {
                    return setLikedCommunityCommentList(page, currentState.loadedPage)
                }
            }
            
        case .didSelectedCell(let row):
            switch currentState.commentType {
            case .liked(_):
                if currentState.perfumeItem.isEmpty {
                    return .concat([
                        .just(.setCommunityId(currentState.communityItem[row].parentId)),
                        .just(.setCommunityId(nil))
                    ])
                } else {
                    return .concat([
                        .just(.setPerfumeId(currentState.perfumeItem[row].parentId)),
                        .just(.setPerfumeId(nil))
                    ])
                }
            case .perfume(_):
                return .concat([
                    .just(.setPerfumeId(currentState.perfumeItem[row].parentId)),
                    .just(.setPerfumeId(nil))
                ])
            case .community(_):
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
            state.items.perfume = item
            
        case .setCommunityItem(let item):
            state.communityItem = item
            state.items.community = item
            
        case .setCommentType(let type):
            state.commentType = type
            
        case .setLoadedPage(let page):
            state.loadedPage = page
            
        case .setPerfumeId(let id):
            state.perfumeId = id
            
        case .setCommunityId(let id):
            state.communityId = id
            
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
                
                var loadedPage: Set<Int>
                if page == 0 { loadedPage = [0] }
                else {
                    loadedPage = self.currentState.loadedPage
                    loadedPage.insert(page)
                }
                
                return .concat([
                    .just(.setPerfumeItem(item)),
                    .just(.setCommunityItem([])),
                    .just(.setLoadedPage(loadedPage)),
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
                
                var loadedPage: Set<Int>
                if page == 0 { loadedPage = [0] }
                else {
                    loadedPage = self.currentState.loadedPage
                    loadedPage.insert(page)
                }
                
                return .concat([
                    .just(.setCommunityItem(item)),
                    .just(.setPerfumeItem([])),
                    .just(.setLoadedPage(loadedPage)),
                    .just(.setCommentType(.community(nil)))
                ])
            }
    }
    
    func setLikedPerfumeCommentList(_ page: Int, _ loadedPage: Set<Int>) -> Observable<Mutation> {
        
        if loadedPage.contains(page) { return .empty() }
        return MemberAPI.fetchLikedPerfumeComments(["page": page])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in

                var item = self.currentState.perfumeItem
                item.append(contentsOf: data)
                var loadedPage = self.currentState.loadedPage
                loadedPage.insert(page)
                
                return .concat([
                    .just(.setPerfumeItem(item)),
                    .just(.setCommunityItem([])),
                    .just(.setLoadedPage(loadedPage))
                ])
            }
    }
    
    func setLikedCommunityCommentList(_ page: Int, _ loadedPage: Set<Int>) -> Observable<Mutation> {
        
        if loadedPage.contains(page) { return .empty() }
        return MemberAPI.fetchLikedCommunityComments(["page": page])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in

                var item = self.currentState.communityItem
                item.append(contentsOf: data)
                var loadedPage = self.currentState.loadedPage
                loadedPage.insert(page)
                
                return .concat([
                    .just(.setPerfumeItem([])),
                    .just(.setCommunityItem(item)),
                    .just(.setLoadedPage(loadedPage))
                ])
            }
    }
}
