//
//  MyLogReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/14.
//

import Foundation

import ReactorKit
import RxSwift

class MyLogReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapCell(Int)
    }
    
    enum Mutation {
        case setSelectedRow(Int?)
    }
    
    struct State {
        var item: [String] = ["좋아요 누른 댓글", "작성한 댓글", "작성한 게시글"]
        var selectedRow: Int? = nil
        
    }
    
    init() {
        initialState = State()
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCell(let row):
            return .concat([
                .just(.setSelectedRow(row)),
                .just(.setSelectedRow(nil))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedRow(let row):
            state.selectedRow = row
        }
        
        return state
    }
}
