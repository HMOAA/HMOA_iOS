//
//  MyLogWritedPostReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/25/23.
//

import ReactorKit
import RxSwift

class MyLogWritedPostReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didSelectedCell(Int)
    }
    
    enum Mutation {
        case setWritedPostItems([CategoryList])
        case setSelectedId(Int?)
    }
    
    struct State {
        var writedPostItems: [CategoryList] = []
        var selectedId: Int? = nil
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setWritedPostItems()
            
        case .didSelectedCell(let row):
            return .concat([
                .just(.setSelectedId(row)),
                .just(.setSelectedId(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setWritedPostItems(let items):
            state.writedPostItems = items
            
        case .setSelectedId(let row):
            if let row = row {
                state.selectedId = state.writedPostItems[row].communityId
            }
        }
        
        return state
    }
}

extension MyLogWritedPostReactor {
    func setWritedPostItems() -> Observable<Mutation> {
        return MemberAPI.fetchWritedPosts(["page": 0])
            .catch { _ in .empty() }
            .map { .setWritedPostItems($0) }
    }
}
