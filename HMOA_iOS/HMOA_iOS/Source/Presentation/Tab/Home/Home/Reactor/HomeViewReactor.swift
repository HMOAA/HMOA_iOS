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
        case didTapBrandSearchButton
        case didTapSearchButton
        case didTapBellButton
    }
    
    enum Mutation {
        case setSelectedPerfumeId(IndexPath?)
        case setIsPresentBrandSearchVC(Bool)
        case setIsPresentSearchVC(Bool)
        case setIsPresentBellVC(Bool)
    }
    
    struct State {
        var sections: [HomeSection]
        var selectedPerfumeId: Int?
        var isPresentBrandSearchVC: Bool = false
        var isPresentSearchVC: Bool = false
        var isPresentBellVC: Bool = false
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
        case .didTapBrandSearchButton:
            return .concat([
                .just(.setIsPresentBrandSearchVC(true)),
                .just(.setIsPresentBrandSearchVC(false))
            ])
            
        case .didTapSearchButton:
            return .concat([
                .just(.setIsPresentSearchVC(true)),
                .just(.setIsPresentSearchVC(false))
            ])
        
        case .didTapBellButton:
            return .concat([
                .just(.setIsPresentBellVC(true)),
                .just(.setIsPresentBellVC(false))
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
            
            if indexPath.section != 0 {
                state.selectedPerfumeId = state.sections[indexPath.section].items[indexPath.item].perfumeId
            }
            
        case .setIsPresentBrandSearchVC(let isPresent):
            state.isPresentBrandSearchVC = isPresent
            
        case .setIsPresentSearchVC(let isPresent):
            state.isPresentSearchVC = isPresent
            
        case .setIsPresentBellVC(let isPresent):
            state.isPresentBellVC = isPresent
        }
        return state

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
            Perfume(perfumeId: 5, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!)
        ]
        
        let homeTopItem = HomeSectionItem.homeTopCell(UIImage(named: "jomalon"), 1)
        
        let homeTopSection = HomeSection.homeTop([homeTopItem])
        
        let homeFirstItem = perfumes.map { HomeSectionItem.homeFirstCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeFirstSection = HomeSection.homeFirst(homeFirstItem)
        
        let homeSecondItem = perfumes.map { HomeSectionItem.homeSecondCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeSecondSection = HomeSection.homeTop(homeSecondItem)
        
        let homeThridItem = perfumes.map { HomeSectionItem.homeThridCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeThridSection = HomeSection.homeSecond(homeThridItem)
        
        
        let homeFourthItem = perfumes.map { HomeSectionItem.homeFourthCell(HomeCellReactor(perfume: $0), $0.perfumeId) }
        
        let homeFourthSection = HomeSection.homeSecond(homeFourthItem)
        
        
        return [homeTopSection, homeFirstSection, homeSecondSection, homeThridSection, homeFourthSection]
    }
}
