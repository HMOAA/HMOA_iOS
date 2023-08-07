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
        case didTapCardItem(IndexPath)
    }
    
    enum Mutation {
        case setShowCardCollectionView(Bool)
        case setShowListCollectionView(Bool)
        case setSelectedPerfumeId(IndexPath?)
    }
    
    struct State {
        var cardSectionItem: [CardSectionItem] = CardSectionItem.items
        var listSectionItem: [ListSectionItem] = ListSectionItem.items
        var isSelectedCard: Bool = true
        var isSelectedList: Bool = false
        var selectedCardIndexPath: IndexPath? = nil
        var selectedPerfumeId: Int? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCardButton:
            return .just(.setShowCardCollectionView(true))
        case .didTapListButton:
            return .just(.setShowListCollectionView(true))
        case .didTapCardItem(let indexPath):
            return .concat([
                .just(.setSelectedPerfumeId(indexPath)),
                .just(.setSelectedPerfumeId(nil))
            ])
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
        case .setSelectedPerfumeId(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedPerfumeId = nil
                return state
            }
            
            state.selectedPerfumeId = state.cardSectionItem[indexPath.item].id
        }
        return state
    }
}
