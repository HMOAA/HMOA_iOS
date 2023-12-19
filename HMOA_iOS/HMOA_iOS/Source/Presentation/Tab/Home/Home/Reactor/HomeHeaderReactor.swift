//
//  HomeHeaderReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/15.
//

import ReactorKit

class HomeHeaderReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didTapMoreButton
    }
    
    enum Mutation {
        case setPresentMoreVC(Int?)
    }
    
    struct State {
        var headerTitle: String
        var listType: Int? = nil
        var isPersentMoreVC: Int? = nil
    }
    
    init(_ title: String, _ listType: Int) {
        print("title :\(title)")
        print("list: \(listType)")
        self.initialState = State(headerTitle: title, listType: listType)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapMoreButton:
            return .concat([
                .just(.setPresentMoreVC(currentState.listType!)),
                .just(.setPresentMoreVC(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentMoreVC(let isPresent):
            state.isPersentMoreVC = isPresent
        }
        
        return state
    }
}
