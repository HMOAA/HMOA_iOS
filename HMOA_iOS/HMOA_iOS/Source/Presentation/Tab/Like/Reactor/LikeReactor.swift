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
        case didTapCollectionViewItem(IndexPath)
        case didTapXButton(Int)
    }
    
    enum Mutation {
        case setShowCardCollectionView(Bool)
        case setShowListCollectionView(Bool)
        case setSelectedPerfumeId(IndexPath?)
        case setSectionItem([Like])
        case setIsHideenNoLikeView(Bool)
    }
    
    struct State {
        var sectionItem: [Like] = []
        var isSelectedCard: Bool = true
        var isSelectedList: Bool = false
        var selectedCardIndexPath: IndexPath? = nil
        var selectedPerfumeId: Int? = nil
        var isHiddenNoLikeView: Bool = true
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCardButton:
            return .concat([
                .just(.setShowCardCollectionView(true)),
                .just(.setShowListCollectionView(false))
            ])
        case .didTapListButton:
            return .concat([
                .just(.setShowCardCollectionView(false)),
                .just(.setShowListCollectionView(true))
            ])
        case .didTapCollectionViewItem(let indexPath):
            return .concat([
                .just(.setSelectedPerfumeId(indexPath)),
                .just(.setSelectedPerfumeId(nil))
            ])
            
        case .viewWillAppear:
            return fetchLikePerfumes()
            
        case .didTapXButton(let row):
            return deleteLikePerfume(row)
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setShowListCollectionView(let isSelected):
            state.isSelectedList = isSelected
        case .setShowCardCollectionView(let isSelected):
            state.isSelectedCard = isSelected
        case .setSelectedPerfumeId(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedPerfumeId = nil
                return state
            }
            
            state.selectedPerfumeId = state.sectionItem[indexPath.item].perfumeID
        case .setSectionItem(let item):
            state.sectionItem = item
            
        case .setIsHideenNoLikeView(let isHidden):
            state.isHiddenNoLikeView = isHidden
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
                let isHidden = !item.isEmpty
                print("22\(isHidden)")
                return .concat([
                    .just(.setSectionItem(item)),
                    .just(.setIsHideenNoLikeView(isHidden))
                ])
            }
    }
    
    func deleteLikePerfume(_ row: Int) -> Observable<Mutation> {
        let id = currentState.sectionItem[row].perfumeID
        return LikeAPI.deleteLike(id)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                var item = self.currentState.sectionItem
                item.remove(at: row)
                
                let isHidden = !item.isEmpty
                
                return .concat([
                    .just(.setSectionItem(item)),
                    .just(.setIsHideenNoLikeView(isHidden))
                ])
            }
    }
    
}
