//
//  HBTINoteReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/15/24.
//
import ReactorKit
import RxSwift

final class HBTIPerfumeSurveyReactor: Reactor {
    
    enum Action {
        case didTapPriceButton(String)
        case didTapNextButton
        case didChangePage(Int)
    }
    
    enum Mutation {
        case setSelectedPrice(String)
        case setIsEnabledNextButton
        case setNextPage(Int)
        case setCurrentPage(Int)
    }
    
    struct State {
        var selectedPrice: String? = nil
        var isEnabledNextButton: Bool = false
        var currentPage: Int = 0
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapPriceButton(let price):
            return .concat([
                .just(.setSelectedPrice(price)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didChangePage(let page):
            return .concat([
                .just(.setCurrentPage(page)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didTapNextButton:
            return .just(.setNextPage(currentState.currentPage + 1))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedPrice(let price):
            state.selectedPrice = state.selectedPrice == price ? nil : price
            
        case .setIsEnabledNextButton:
            if state.currentPage == 0 {
                state.isEnabledNextButton = state.selectedPrice != nil
            } else {
                // TODO: 향료 state에 따라 업데이트
                state.isEnabledNextButton = false
            }
            
        case .setNextPage(let page):
            guard page < 2 else { break }
            state.currentPage = page
            
        case .setCurrentPage(let row):
            state.currentPage = row
        }
        
        return state
    }
}
