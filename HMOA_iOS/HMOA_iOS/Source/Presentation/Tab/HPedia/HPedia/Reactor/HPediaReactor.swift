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
        case didTapDictionaryItem(IndexPath?)
    }
    
    struct State {
        var DictionarySectionItems: [HPediaDictionaryData] = HPediaDictionaryData.list
        var qnASectionItems: [HPediaQnAData] = HPediaQnAData.list
        
        var selectedDictionaryId: Int? = nil
    }
    
    enum Mutation {
        case setDictionaryIndexPath(IndexPath?)
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDictionaryItem(let indexPath):
            return .concat([
                .just(.setDictionaryIndexPath(indexPath)),
                .just(.setDictionaryIndexPath(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = initialState
        switch mutation {
        case .setDictionaryIndexPath(let indexPath):
            guard let indexPath = indexPath else {
                return state
            }
            state.selectedDictionaryId = state.DictionarySectionItems[indexPath.section].id
        }
        
        return state
    }
}
