//
//  HomeViewReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import ReactorKit
import RxCocoa

final class HomeViewReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case itemSelected(IndexPath)
    }
    
    enum Mutation {
        case setSelectedPerfumeId(IndexPath?)
    }
    
    struct State {
        var sections: [HomeSection]
        var selectedPerfumeId: Int?
    }
    
    init() {
        self.initialState = State(
            sections: HomeViewReactor.setUpSections()
        )
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .itemSelected(let indexPath):
            return .concat([
                Observable<Mutation>.just(.setSelectedPerfumeId(indexPath)),
                Observable<Mutation>.just(.setSelectedPerfumeId(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedPerfumeId(let indexPath):
            
            guard let indexPath = indexPath else {
                state.selectedPerfumeId = nil
                return state
            }
            
            state.selectedPerfumeId = state.sections[indexPath.section].items[indexPath.item].perfumeId
            
            return state
            
        }
    }
}

extension HomeViewReactor {
    
    static func setUpSections() -> [HomeSection] {
        
        // TODO: 더미 데이터 -> 실제 데이터 서버에서 받아오면 수정
        let perfumes = [
            Perfume(perfumeId: 1, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 2, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 3, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 4, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 5, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 6, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 7, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!)
        ]
        
        let homeTopItem = HomeSectionItem.homeTopCell(UIImage(named: "jomalon"), 1)
        
        let homeTopSection = HomeSection.homeTop([homeTopItem])
        
        let homeFirstItem = perfumes.map { HomeSectionItem.homeFirstCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeFirstSection = HomeSection.homeTop(homeFirstItem)
        
        let homeSecondItem = perfumes.map { HomeSectionItem.homeSecondCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeSecondSection = HomeSection.homeSecond(homeSecondItem)
        
        let homeWatchItem = perfumes.map { HomeSectionItem.homeWatchCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeWatchSection = HomeSection.homeWatch(homeWatchItem)
        
        return [homeTopSection, homeFirstSection, homeSecondSection, homeWatchSection]
    }
}
