//
//  MagazineReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import Foundation

import ReactorKit
import RxSwift

class MagazineReactor: Reactor {
    
    enum Action {
        case didSelectMagazineItem(IndexPath)
    }
    
    enum Mutation {
        case navigateToDetail(MagazineItem)
    }
    
    struct State {
        var selectedItem: MagazineItem?
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectMagazineItem(let indexPath):
            let magazine = MagazineItem.mainMagazines[indexPath.item]
            return Observable.just(.navigateToDetail(magazine))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .navigateToDetail(let magazine):
            state.selectedItem = magazine
        }
        return state
    }
}
