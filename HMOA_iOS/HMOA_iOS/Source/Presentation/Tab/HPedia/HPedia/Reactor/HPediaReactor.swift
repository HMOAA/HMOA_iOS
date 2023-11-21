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
        case didTapDictionaryItem(Int?)
        case didTapCommunityItem(Int?)
        case viewWillAppear
    }
    
    struct State {
        var DictionarySectionItems: [HPediaDictionaryData] = HPediaDictionaryData.list
        var communityItems: [CategoryList] = []
        var selectedDictionaryId: Int? = nil
        var selectedCommunityId: Int? = nil
    }
    
    enum Mutation {
        case setSelectedDictionaryItemId(Int?)
        case setSelectedCommunityItemId(Int?)
        case setCommunityItems([CategoryList])
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDictionaryItem(let row):
            return .concat([
                .just(.setSelectedDictionaryItemId(row)),
                .just(.setSelectedDictionaryItemId(nil))
            ])
        case .didTapCommunityItem(let row):
            return .concat([
                    .just(.setSelectedCommunityItemId(row)),
                    .just(.setSelectedCommunityItemId(nil))
                ])
        case .viewWillAppear:
            return setHpediaCommunityListItem()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = initialState
        switch mutation {
            
        case .setSelectedDictionaryItemId(let itemId):
            guard let itemId = itemId else {
                return state
            }
            state.selectedDictionaryId = state.DictionarySectionItems[itemId].id
            
        case .setSelectedCommunityItemId(let row):
            guard let row = row else { return state }
            state.selectedCommunityId = currentState.communityItems[row].communityId
            print(currentState.communityItems[row].communityId)
        case .setCommunityItems(let item):
            state.communityItems = item
        }
        
        return state
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
}
