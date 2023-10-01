//
//  QnADetailReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import Foundation

import ReactorKit
import RxSwift

class QnADetailReactor: Reactor {
    let initialState: State
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
    }
    
    enum Mutation {
        case setSections([QnADetailSection])
    }
    
    struct State {
        var communityId: Int
        var sections: [QnADetailSection] = []
    }
    
    init(_ id: Int) {
        initialState = State(communityId: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setUpPostSection()
            
        case .viewWillAppear:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSections(let sections):
            state.sections = sections
        }
        
        return state
    }
}

extension QnADetailReactor {
    func setUpPostSection() -> Observable<Mutation> {
        return CommunityAPI.fetchCommunityDetail(currentState.communityId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let item = QnADetailSectionItem.qnaPostCell(data)
                let section = QnADetailSection.qnaPost([item])
                
                return .just(.setSections([section]))
            }
    }
}
