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
        case viewWillDisappear
        case didTapCardButton
        case didTapListButton
        case didTapCollectionViewItem(IndexPath)
        case didTapXButton
        case didChangeCurrentPage(Int)
    }
    
    enum Mutation {
        case setShowCardCollectionView(Bool)
        case setShowListCollectionView(Bool)
        case setSelectedPerfumeId(IndexPath?)
        case setSectionItem([Like])
        case setIsHideenNoLikeView(Bool?)
        case setIsDeletedLast(Bool)
        case setCurrentRow(Int)
    }
    
    struct State {
        var sectionItem: [Like] = []
        var isSelectedCard: Bool = true
        var isSelectedList: Bool = false
        var selectedCardIndexPath: IndexPath? = nil
        var selectedPerfumeId: Int? = nil
        var isHiddenNoLikeView: Bool? = nil
        var isDeletedLast: Bool = false
        var currentRow: Int = 0
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
            return .concat([
                .just(.setIsHideenNoLikeView(nil)),
                fetchLikePerfumes()
            ])
            
        case .didTapXButton:
            return deleteLikePerfume()
            
        case .didChangeCurrentPage(let currentRow):
            return .just(.setCurrentRow(currentRow))
            
        case .viewWillDisappear:
            return .just(.setSectionItem([]))
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
            
        case .setIsDeletedLast(let isDeleted):
            state.isDeletedLast = isDeleted
            
        case .setCurrentRow(let row):
            state.currentRow = row
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
        
                return .concat([
                    .just(.setSectionItem(item)),
                    .just(.setIsHideenNoLikeView(isHidden))
                ])
            }
    }
    
    func deleteLikePerfume() -> Observable<Mutation> {
        let row = currentState.currentRow
        let id = currentState.sectionItem[row].perfumeID
        return LikeAPI.deleteLike(id)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                var item = self.currentState.sectionItem
                item.remove(at: row)
                
                let isHidden = !item.isEmpty
                
                if row == item.count {
                    return .concat([
                        .just(.setIsDeletedLast(true)),
                        .just(.setIsDeletedLast(false)),
                        .just(.setSectionItem(item)),
                        .just(.setIsHideenNoLikeView(isHidden))
                    ])
                } else {
                    return .concat([
                        .just(.setSectionItem(item)),
                        .just(.setIsHideenNoLikeView(isHidden))
                    ])
                }
            }
    }
    
}
