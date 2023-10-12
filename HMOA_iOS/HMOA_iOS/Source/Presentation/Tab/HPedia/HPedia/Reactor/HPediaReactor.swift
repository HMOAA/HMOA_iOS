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
    }
    
    struct State {
        var DictionarySectionItems: [HPediaDictionaryData] = HPediaDictionaryData.list
        var qnASectionItems: [CategoryList] = []
        
        var selectedDictionaryId: Int? = nil
        var selectedCommunityId: Int? = nil
    }
    
    enum Mutation {
        case setSelectedDictionaryItemId(Int?)
        case setSelectedCommunityItemId(Int?)
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDictionaryItem(let itemId):
            return .concat([
                .just(.setSelectedDictionaryItemId(itemId)),
                .just(.setSelectedDictionaryItemId(nil))
            ])
        case .didTapCommunityItem(let itemId):
            return .concat([
                    .just(.setSelectedCommunityItemId(itemId)),
                    .just(.setSelectedCommunityItemId(nil))
                ])
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
        case .setSelectedCommunityItemId(let itemId):
            guard let itemId = itemId else { return state }
            state.selectedCommunityId = 1
        }
        
        return state
    }
}
