//
//  LikeReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import UIKit
import ReactorKit

class LikeReactor: Reactor {
    
    let initialState: State
    
    init() {
        initialState = State()
    }
    
    enum Action {
        case didTapCardButton
        case didTapListButton
    }
    
    enum Mutation {
        case setShowCardCollectionView(Bool)
        case setShowListCollectionView(Bool)
    }
    
    struct State {
        var cardSections: [CardSection] = [CardSection(items: CardData.items)]
        var listSections: [ListSection] = [ListSection(items: ListData.items)]
        var isSelectedCard: Bool = true
        var isSelectedList: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCardButton:
            return .just(.setShowCardCollectionView(true))
        case .didTapListButton:
            return .just(.setShowListCollectionView(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setShowListCollectionView(let isSelected):
            state.isSelectedCard = !isSelected
            state.isSelectedList = isSelected
        case .setShowCardCollectionView(let isSelected):
            state.isSelectedCard = isSelected
            state.isSelectedList = !isSelected
        }
        
        return state
    }
}
