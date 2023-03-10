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
        case didBeginTextViewEditing
        case didEndTextViewEditing
    }
    
    enum Mutation {
        case setIsBeginEditing(Bool)
        case setIsEndEditing(Bool)
        case setIsPopVC(Bool)
    }
    
    struct State {
        var content: String
        var isPopVC: Bool = false
        var isBeginEditing: Bool = false
        var isEndEditing: Bool = false
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
        case .didBeginTextViewEditing:
            return .concat([
                .just(.setIsBeginEditing(true)),
                .just(.setIsBeginEditing(false))
            ])
        
        case .didEndTextViewEditing:
            return .concat([
                .just(.setIsEndEditing(true)),
                .just(.setIsEndEditing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
        case .setIsBeginEditing(let isEditing):
            state.isBeginEditing = isEditing
        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
        }
        
        return state
    }
}
