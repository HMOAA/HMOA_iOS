//
//  HBTINotesResultReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/8/24.
//

import RxSwift
import ReactorKit

final class HBTINotesResultReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case didTapNextButton
    }
    
    enum Mutation {
        case setCartItemList([HBTINotesResultItem])
        case setTotalPrice(Int)
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        let selectedNoteList: [Int]
        var cartItemList: [HBTINotesResultItem] = []
        var totalPrice: Int = 0
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init(_ selectedNoteList: [Int]) {
        self.initialState = State(selectedNoteList: selectedNoteList)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            return setCartItemList()

        case .didTapNextButton:
            return .just(.setIsPushNextVC(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setCartItemList(let item):
            state.cartItemList = item
            
        case .setTotalPrice(let price):
            state.totalPrice = price
            
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}

extension HBTINotesResultReactor {
    func setCartItemList() -> Observable<Mutation> {
        let selectedNoteList = currentState.selectedNoteList
        
        return HBTIAPI.postNoteListToCart(params: ["productIds": selectedNoteList])
            .catch{ _ in .empty() }
            .flatMap { notesResultData -> Observable<Mutation> in
                let cartItemList = notesResultData.categoryList.map { noteItem in
                    return HBTINotesResultItem.notesResult(noteItem)
                }
                let totalPrice = notesResultData.totalPrice
                
                return .concat([
                    .just(.setCartItemList(cartItemList)),
                    .just(.setTotalPrice(totalPrice))
                ])
            }
    }
}

