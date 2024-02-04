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
    }
    
    init() {
        initialState = State()
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
            return setHpediaCommunityListItem()
            
        case .viewDidLoad(let isLogin):
            return .just(.setIsLogin(isLogin))
            
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
        }
        
        return state
    }
}

extension HPediaReactor {
    func setHpediaCommunityListItem() -> Observable<Mutation> {
        return CommunityAPI.fetchHPediaCategoryList()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return
                    .concat([
                    .just(.setCommunityItems(data)),
                    .just(.setIsTapFloatingButton(false))
                    ])
            }
        
    }
    
    func reactorForWrite() -> CommunityWriteReactor {
        return CommunityWriteReactor(
            communityId: nil,
            title: nil,
            category: currentState.selectedAddCategory!,
            photos: [],
            service: nil)
    }
}
