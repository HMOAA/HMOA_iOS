//
//  ImagePinchReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/15/23.
//

import Foundation
import ReactorKit
import RxSwift

class ImagePinchReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapXButton
        case didScrollToTop
    }
    
    enum Mutation {
        case setIsDismiss(Bool)
    }
    
    struct State {
        var images: [CommunityPhoto]
        var selectedRow: Int
        var isDismiss: Bool = false
    }
    
    init(_ selectedRow: Int, _ images: [CommunityPhoto]) {
        initialState = State(images: images, selectedRow: selectedRow)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapXButton, .didScrollToTop:
            return .concat([
                .just(.setIsDismiss(true)),
                .just(.setIsDismiss(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIsDismiss(let isDismiss):
            state.isDismiss = isDismiss
        }
        
        return state
    }
}
