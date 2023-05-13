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
        case viewDidLoad
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
        case setSections([HomeSection])
    }
    
    struct State {
        var sections: [HomeSection] = []
        var selectedPerfumeId: Int?
        var isPresentBrandSearchVC: Bool = false
        var isPresentSearchVC: Bool = false
        var isPresentBellVC: Bool = false
    }
    
    init() {
        self.initialState = State()
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return HomeViewReactor.reqeustHomeData()
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
        
        case .setSections(let sections):
            state.sections = sections
        }
        return state

    }
}

extension HomeViewReactor {
    
    static func reqeustHomeData() -> Observable<Mutation> {

        return HomeAPI.getHomeData()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let homeTopItem = HomeSectionItem.homeTopCell(data.mainImage, 1)
                
                let homeTopSection = HomeSection.homeTop([homeTopItem])
                
                let homeFirstItem = data.recommend[0].perfumeList.map { HomeSectionItem.homeFirstCell(HomeCellReactor(perfume: $0), $0.id) }
                
                let homeFirstSection = HomeSection.homeFirst(header: data.recommend[0].title, items: homeFirstItem)
                
                let homeSecondItem = data.recommend[1].perfumeList.map { HomeSectionItem.homeSecondCell(HomeCellReactor(perfume: $0), $0.id) }
                
                let homeSecondSection = HomeSection.homeSecond(header: data.recommend[1].title, items: homeSecondItem)
                
                let homeThridItem = data.recommend[2].perfumeList.map { HomeSectionItem.homeThridCell(HomeCellReactor(perfume: $0), $0.id) }
                
                let homeThridSection = HomeSection.homeThrid(header: data.recommend[2].title, items: homeThridItem)
                
                
                let homeFourthItem = data.recommend[3].perfumeList.map { HomeSectionItem.homeFourthCell(HomeCellReactor(perfume: $0), $0.id) }
                
                let homeFourthSection = HomeSection.homeFourth(header: data.recommend[3].title, items: homeFourthItem)
                
                let sections = [homeTopSection, homeFirstSection, homeSecondSection, homeThridSection, homeFourthSection]
                
                return .just(.setSections(sections))
            }
        
    }
}
