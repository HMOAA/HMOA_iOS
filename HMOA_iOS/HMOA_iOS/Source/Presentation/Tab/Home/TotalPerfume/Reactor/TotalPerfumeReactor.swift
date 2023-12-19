//
//  TotalPerfumeReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import Foundation
import ReactorKit

class TotalPerfumeReactor: Reactor {
    
    enum Action {
        case didTapItem(RecommendPerfume)
        case fetchTotalPerfumes
    }
    
    enum Mutation {
        case setSection([TotalPerfumeSection])
        case setSelectedItem(RecommendPerfume?)
    }
    
    struct State {
        var listType: Int
        var sections: [TotalPerfumeSection] = []
        var selectedItem: RecommendPerfume? = nil
    }
    
    var initialState: State
    
    init(_ listType: Int) {
        initialState = State(listType: listType)
        action.onNext(.fetchTotalPerfumes)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapItem(let perfume):
            return .concat([
                .just(.setSelectedItem(perfume)),
                .just(.setSelectedItem(nil))
            ])
            
        case .fetchTotalPerfumes:
            return setSection()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedItem(let perfume):
            state.selectedItem = perfume
            
        case .setSection(let sections):
            state.sections = sections
        }
        
        return state
    }
}

extension TotalPerfumeReactor {
    func setSection() -> Observable<Mutation> {
        var url: TotalPerfumeAddress {
            switch currentState.listType {
            case 1:
                return .fetchFirstMenu
            case 2:
                return .fetchSecondMenu
            default:
                return .fetchThirdMenu
            }
        }
        return TotalPerfumeAPI.fetchTotalPerfumeList(url: url)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let items = data.map { TotalPerfumeSectionItem.perfumeList($0) }
                let sections = [TotalPerfumeSection.first(items)]
                return .just(.setSection(sections))
            }
    }
}
