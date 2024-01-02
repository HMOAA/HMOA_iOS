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
        case willDisplayCell(Int)
    }
    
    enum Mutation {
        case setWritedPostItems([CategoryList])
        case setSelectedId(Int?)
        case setLoadedPage(Int)
    }
    
    struct State {
        var writedPostItems: [CategoryList] = []
        var selectedId: Int? = nil
        var loadedPage: Set<Int> = []
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setWritedPostItems(0)
            
        case .didSelectedCell(let row):
            return .concat([
                .just(.setSelectedId(row)),
                .just(.setSelectedId(nil))
            ])
            
        case .willDisplayCell(let page):
            return setWritedPostItems(page)
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
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
        }
        
        return state
    }
}

extension MyLogWritedPostReactor {
    func setWritedPostItems(_ page: Int) -> Observable<Mutation> {
        
        if currentState.loadedPage.contains(page) { return .empty() }
        
        return MemberAPI.fetchWritedPosts(["page": page])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var item = self.currentState.writedPostItems
                item.append(contentsOf: data)
                
                return .concat(
                    .just(.setLoadedPage(page)),
                    .just(.setWritedPostItems(item))
                )
            }
    }
}
