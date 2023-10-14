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
        
    }
    
    enum Mutate {
        
    }
    
    struct State {
        var item: [String] = ["좋아요 누른 댓글", "작성한 댓글", "작성한 게시글"]
    }
    
    init() {
        initialState = State()
    }
    
//    func mutate(action: Action) -> Observable<Action> {
//        <#code#>
//    }
//    
//    func reduce(state: State, mutation: Action) -> State {
//        <#code#>
//    }
}
