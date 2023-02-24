//
//  CommentWriteReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/22.
//

import ReactorKit
import RxSwift

class CommentWriteReactor: Reactor {
    var initialState: State
    var currentPerfumeId: Int
    
    enum Action {
        case didTapOkButton
        case didTapCancleButton
    }
    
    enum Mutation {
        case setIsPopVC(Bool)
    }
    
    struct State {
        var content: String
        var isPopVC: Bool = false
    }
    
    init(_ currentPerfumeId: Int) {
        self.currentPerfumeId = currentPerfumeId
        self.initialState = State(content: "")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOkButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
        case .didTapCancleButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
        }
        
        return state
    }
}
