//
//  SearchReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/23.
//

import ReactorKit
import RxSwift

class SearchReactor: Reactor {
    
    enum Action {
        case keywordViewDidLoad
        case didTapBackButton
        case didChangeTextField
        case didEndTextField
    }
    
    enum Mutation {
        case isPopVC(Bool)
        case isChangeToResultVC(Bool)
        case isChangeToListVC(Bool)
        case setKeyword([String])
    }
    
    struct State {
        var Content: String = ""
        var isPopVC: Bool = false
        var isChangeTextField: Bool = false
        var isEndTextField: Bool = false
        var keywords: [String] = []
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .keywordViewDidLoad:
            return requestKeyword()
        case .didTapBackButton:
            return .concat([
                .just(.isPopVC(true)),
                .just(.isPopVC(false))
            ])
        case .didChangeTextField:
            return .concat([
                .just(.isChangeToListVC(true)),
                .just(.isChangeToListVC(false))
            ])
        case .didEndTextField:
            return .concat([
                .just(.isChangeToResultVC(true)),
                .just(.isChangeToResultVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setKeyword(let keywords):
            state.keywords = keywords
        case .isPopVC(let isPop):
            state.isPopVC = isPop
        case .isChangeToListVC(let isChange):
            state.isChangeTextField = isChange
        case .isChangeToResultVC(let isEnd):
            state.isEndTextField = isEnd
        }
        
        return state
    }
}

extension SearchReactor {
    
    func requestKeyword() -> Observable<Mutation> {
        
        // TODO: - 서버 통신해서 키워드 받아오기
        
        let data = ["자연", "도손", "오프레옹", "롬브로단로", "우드앤세이지", "딥티크", "르라보", "선물", "크리스찬디올", "존바바토스", "30대"]
        
        return .concat([
            .just(.setKeyword(data))
        ])
    }
}
