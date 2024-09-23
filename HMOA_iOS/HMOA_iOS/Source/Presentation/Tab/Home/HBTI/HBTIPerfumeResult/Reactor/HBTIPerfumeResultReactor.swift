//
//  HBTIPerfumeResultReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import ReactorKit
import RxSwift

final class HBTIPerfumeResultReactor: Reactor {
    
    enum Action {
        case didTapNextButton
        case didTapPriorityButton(ResultPriority)
        case didTapPerfumeCell(IndexPath)
    }
    
    enum Mutation {
        case setIsPushNextVC
        case setResultPriority(ResultPriority)
        case setSelectedPerfumeID(IndexPath?)
    }
    
    struct State {
        let minPrice: Int
        let maxPrice: Int
        let selectedNoteList: [String]
        var perfumeList: [HBTIPerfumeResultItem] = [
            .perfume(HBTIPerfume(id: 32, nameKR: "한국 이름1", nameEN: "English name1", price: 40000)),
            .perfume(HBTIPerfume(id: 22, nameKR: "한국 이름2", nameEN: "English name2", price: 540000)),
            .perfume(HBTIPerfume(id: 12, nameKR: "한국 이름3", nameEN: "English name3", price: 12000))
        ]
        var isPushNextVC: Bool = false
        var resultPriority: ResultPriority = .price
        var selectedPerfumeID: Int? = nil
    }
    
    var initialState: State
    
    init(_ minPrice: Int, _ maxPrice: Int, _ notes: [String]) {
        self.initialState = State(minPrice: minPrice, maxPrice: maxPrice, selectedNoteList: notes)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPushNextVC)
            
        case .didTapPriorityButton(let priority):
            return .just(.setResultPriority(priority))
            
        case .didTapPerfumeCell(let indexPath):
            return .concat([
                .just(.setSelectedPerfumeID(indexPath)),
                .just(.setSelectedPerfumeID(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPushNextVC:
            state.isPushNextVC = true
            
        case .setResultPriority(let priority):
            state.resultPriority = priority
            
        case .setSelectedPerfumeID(let indexPath):
            guard let indexPath = indexPath else { 
                state.selectedPerfumeID = nil
                break
            }
            state.selectedPerfumeID = state.perfumeList[indexPath.row].perfume?.id
        }
        
        return state
    }
}
