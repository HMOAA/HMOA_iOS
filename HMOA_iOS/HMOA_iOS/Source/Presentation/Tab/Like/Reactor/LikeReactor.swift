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
        case viewWillAppear
        case didTapCardButton
        case didTapListButton
        case didTapCardItem(IndexPath)
    }
    
    enum Mutation {
        case setShowCardCollectionView(Bool)
        case setShowListCollectionView(Bool)
        case setSelectedPerfumeId(IndexPath?)
        case setSectionItem([Like])
    }
    
    struct State {
        var sectionItem: [Like] = []
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
        case .viewWillAppear:
            return fetchLikePerfumes()
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
            
            //state.selectedPerfumeId = state.cardSectionItem[indexPath.item].id
        case .setSectionItem(let item):
            state.sectionItem = item
        }
        return state
    }
}

extension LikeReactor {
    
    func fetchLikePerfumes() -> Observable<Mutation> {
        return LikeAPI.fetchLikeList()
            .catch { _ in .empty() }
            .flatMap { list -> Observable<Mutation> in
                let item: [Like] = list.likePerfumes
                
                return .concat([
                    .just(.setSectionItem(item))
                ])
            }
    }
}
