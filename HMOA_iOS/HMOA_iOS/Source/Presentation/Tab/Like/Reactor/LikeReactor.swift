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
        case didTapListItem(IndexPath)
        case didTapCardItem(IndexPath)
        case didTapCardButton
        case didTapListButton
    }
    
    enum Mutation {
        case setSelectedIndexPath(IndexPath?)
        case setShowCardCollectionView(Bool)
        case setShowListCollectionView(Bool)
    }
    
    struct State {
        var cardSections: [CardSection] = [CardSection(items: CardData.items)]
        var listSections: [ListSection] = [ListSection(items: ListData.items)]
        var isSelectedCard: Bool = true
        var isSelectedList: Bool = false
        var selectedPerpumeId: Int? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCardButton:
            return .just(.setShowCardCollectionView(true))
        case .didTapListButton:
            return .just(.setShowListCollectionView(true))
        case .didTapListItem(let indexPath),
                .didTapCardItem(let indexPath):
            return .concat ([
                .just(.setSelectedIndexPath(indexPath)),
                .just(.setSelectedIndexPath(nil))
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
        case .setSelectedIndexPath(let indexPath):
            guard let indexPath = indexPath
            else {
                state.selectedPerpumeId = nil
                return state
            }
            state.selectedPerpumeId = state.listSections[indexPath.section].items[indexPath.item].id
        }
        
        return state
    }
}
