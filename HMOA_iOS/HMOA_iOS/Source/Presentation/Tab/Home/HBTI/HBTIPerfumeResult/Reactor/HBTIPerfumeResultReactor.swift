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
        case viewDidLoad
        case didTapNextButton
        case didTapPriorityButton(ResultPriority)
        case didTapPerfumeCell(IndexPath)
    }
    
    enum Mutation {
        case setPerfumeList([HBTIPerfumeResultItem])
        case setIsPushNextVC
        case setResultPriority(ResultPriority)
        case setSelectedPerfumeID(IndexPath?)
    }
    
    struct State {
        let minPrice: Int
        let maxPrice: Int
        let selectedNoteList: [String]
        var perfumeList: [HBTIPerfumeResultItem] = []
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
        case .viewDidLoad:
            return setPerfumeList(isContainAll: false)
            
        case .didTapNextButton:
            return .just(.setIsPushNextVC)
            
        case .didTapPriorityButton(let priority):
            let noteFirst = priority == .note
            
            return .concat([
                .just(.setResultPriority(priority)),
                setPerfumeList(isContainAll: noteFirst)
            ])
            
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
        case .setPerfumeList(let item):
            state.perfumeList = item
            
        case .setIsPushNextVC:
            state.isPushNextVC = true
            
        case .setResultPriority(let priority):
            state.resultPriority = priority
            
        case .setSelectedPerfumeID(let indexPath):
            guard let indexPath = indexPath else { 
                state.selectedPerfumeID = nil
                break
            }
            state.selectedPerfumeID = state.perfumeList[indexPath.row].perfume!.id
        }
        
        return state
    }
}

extension HBTIPerfumeResultReactor {
    private func setPerfumeList(isContainAll: Bool) -> Observable<Mutation> {
        let maxPrice = currentState.maxPrice
        let minPrice = currentState.minPrice
        let notes = currentState.selectedNoteList
        
        let params: [String: Any] = [
            "maxPrice": maxPrice,
            "minPrice": minPrice,
            "notes": notes
        ]
        
        return HBTIAPI.postPerfumeAnswer(params: params, isContainAll: isContainAll)
            .catch { _ in .empty() }
            .flatMap { perfumeListData -> Observable<Mutation> in
                let perfumeList = perfumeListData.perfumeList.map { perfumeData in
                    return HBTIPerfumeResultItem.perfume(perfumeData)
                }
                return .just(.setPerfumeList(perfumeList))
            }
    }
}
