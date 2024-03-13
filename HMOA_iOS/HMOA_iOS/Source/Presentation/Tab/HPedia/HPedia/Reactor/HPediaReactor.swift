//
//  HPediaReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

import ReactorKit
import RxSwift

class HPediaReactor: Reactor {
    
    var initialState: State
    let service: CommunityListProtocol
    
    enum Action {
        case didTapDictionaryItem(Int)
        case didTapCommunityItem(Int)
        case viewDidLoad(Bool)
        case viewWillAppear
        case didTapFloatingButton
        case didTapRecommendButton
        case didTapReviewButton
        case didTapEtcButton
        case didTapFloatingBackView
    }
    
    struct State {
        var DictionarySectionItems: [HPediaDictionaryData] = HPediaDictionaryData.list
        var communityItems: [CategoryList] = []
        var selectedHPedia: HpediaType? = nil
        var selectedCommunityId: Int? = nil
        var isLogin: Bool = false
        var selectedAddCategory: String? = nil
        var isFloatingButtonTap: Bool = false
        var isTapWhenNotLogin: Bool = false
    }
    
    enum Mutation {
        case setSelectedHPedia(Int?)
        case setSelectedCommunityItemId(Int?)
        case setCommunityItems([CategoryList])
        case setIsTapFloatingButton(Bool)
        case setSelectedAddCategory(String?)
        case setIsLogin(Bool)
        case setIsTapWhenNotLogin(Bool)
        case addCommunityPost(CategoryList)
        case deleteCommunityPost(CategoryList)
        case updateCommunityPost(CategoryList)
    }
    
    init(service: CommunityListProtocol) {
        initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDictionaryItem(let row):
            return .concat([
                .just(.setSelectedHPedia(row)),
                .just(.setSelectedHPedia(nil))
            ])
            
        case .didTapCommunityItem(let row):
            return .concat([
                .just(.setSelectedCommunityItemId(row)),
                .just(.setSelectedCommunityItemId(nil))
            ])
        case .viewWillAppear:
            return .just(.setIsTapFloatingButton(false))
            
        case .viewDidLoad(let isLogin):
            return .concat([
                .just(.setIsLogin(isLogin)),
                setHpediaCommunityListItem()
            ])
            
        case .didTapFloatingButton:
            if currentState.isLogin {
                return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
            } else {
                return .concat([
                    .just(.setIsTapWhenNotLogin(true)),
                    .just(.setIsTapWhenNotLogin(false))
                ])
            }
            
        case .didTapRecommendButton:
            return .concat([
                .just(.setSelectedAddCategory("추천")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapReviewButton:
            return .concat([
                .just(.setSelectedAddCategory("시향기")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapEtcButton:
            return .concat([
                .just(.setSelectedAddCategory("자유")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapFloatingBackView:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
        case .setSelectedHPedia(let row):
            if let row = row {
                state.selectedHPedia = state.DictionarySectionItems[row].type
            } else { state.selectedHPedia = nil }
            
        case .setSelectedCommunityItemId(let row):
            if let row = row {
                state.selectedCommunityId = currentState.communityItems[row].communityId
            } else { state.selectedCommunityId = nil }
            
        case .setCommunityItems(let item):
            state.communityItems = item
            
        case .setIsTapFloatingButton(let isTap):
            state.isFloatingButtonTap = isTap
            
        case .setSelectedAddCategory(let category):
            state.selectedAddCategory = category
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
            
        case .setIsTapWhenNotLogin(let isTap):
            state.isTapWhenNotLogin = isTap
            
        case .updateCommunityPost(let community):
            if let index = state.communityItems.firstIndex(where: { $0.communityId == community.communityId }) {
                state.communityItems[index] = community
            }
            
        case .addCommunityPost(let community):
            state.communityItems.insert(community, at: 0)
            
        case .deleteCommunityPost(let community):
            state.communityItems.removeAll { $0.communityId == community.communityId }
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .addCommunityList(let community):
                return .just(.addCommunityPost(community))
            case .deleteCommunityList(let community):
                return .just(.deleteCommunityPost(community))
            case .updateCommunityList(let community):
                return .just(.updateCommunityPost(community))
            default: return .empty()
            }
        }
        
        return .merge(eventMutation, mutation)
    }
}

extension HPediaReactor {
    
    func setHpediaCommunityListItem() -> Observable<Mutation> {
        return CommunityAPI.fetchHPediaCategoryList()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setCommunityItems(data))
            }
    }
    
    func reactorForWrite() -> CommunityWriteReactor {
        return CommunityWriteReactor(
            communityId: nil,
            title: nil,
            category: currentState.selectedAddCategory!,
            photos: [],
            service: service)
    }
    
    func reactorForDetail() -> CommunityDetailReactor {
        return CommunityDetailReactor(currentState.selectedCommunityId!, service)
    }
    
    func reactorForCommunityList() -> CommunityListReactor {
        return CommunityListReactor(service: service)
    }
}
