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
        case didTapMagazineCell(IndexPath)
    }
    
    enum Mutation {
        case navigateToMagazineDetail(MagazineItem)
    }
    
    struct State {
        var mainBannerItems: [MagazineItem] = []
        var newPerfumeItems: [MagazineItem] = []
        var topReviewItems: [MagazineItem] = []
        var allMagazineItems: [MagazineItem] = []
        var selectedMagazine: MagazineItem? = nil
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapMagazineCell(let indexPath):
            let magazine = MagazineItem.mainMagazines[indexPath.item]
            return Observable.just(.navigateToMagazineDetail(magazine))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .navigateToMagazineDetail(let magazine):
            state.selectedMagazine = magazine
        }
        return state
    }
}
