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
        case scrollCollectionView
    }
    
    enum Mutation {
        case setSelectedPerfumeId(IndexPath?)
        case setIsPresentBrandSearchVC(Bool)
        case setIsPresentSearchVC(Bool)
        case setIsPresentBellVC(Bool)
        case setSections([HomeSection])
        case setPagination(Bool)
    }
    
    struct State {
        var sections: [HomeSection] = []
        var selectedPerfumeId: Int?
        var selectedPerfumeImage: String? = nil
        var isPresentBrandSearchVC: Bool = false
        var isPresentSearchVC: Bool = false
        var isPresentBellVC: Bool = false
        var isPaging: Bool = false
    }
    
    init() { self.initialState = State() }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return HomeViewReactor.reqeustHomeFirstData()
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
            
        case .scrollCollectionView:
            return .concat([
                HomeViewReactor.requstHomeSecondData(currentState),
                .just(.setPagination(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedPerfumeId(let indexPath):
            
            guard let indexPath = indexPath else {
                state.selectedPerfumeId = nil
                state.selectedPerfumeImage = nil
                return state
            }
            
            if indexPath.section != 0 {
                state.selectedPerfumeId = state.sections[indexPath.section].items[indexPath.item].perfumeId
                state.selectedPerfumeImage =
                state.sections[indexPath.section].items[indexPath.item].perfumeImage
            }
            
        case .setIsPresentBrandSearchVC(let isPresent):
            state.isPresentBrandSearchVC = isPresent
            
        case .setIsPresentSearchVC(let isPresent):
            state.isPresentSearchVC = isPresent
            
        case .setIsPresentBellVC(let isPresent):
            state.isPresentBellVC = isPresent
            
        case .setPagination(let isPaging):
            state.isPaging = isPaging
            
        case .setSections(let sections):
            state.sections = sections
        }
        return state
    }
}

extension HomeViewReactor {
    
    static func reqeustHomeFirstData() -> Observable<Mutation> {
        
        return HomeAPI.getFirstHomeData()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var sections = [HomeSection]()
                
                let homeTopItem = HomeSectionItem.topCell(data.mainImage, 1)
                let homeTopSection = HomeSection.topSection([homeTopItem])
                let recommend = data.recommend
                
                sections.append(homeTopSection)
                
                let item = recommend.perfumeList.map { HomeSectionItem.recommendCell($0, $0.id, UUID())}
                
                sections.append(HomeSection.recommendSection(header: recommend.title, items: item))
                
                return .just(.setSections(sections))
            }
    }
    
    
    static func requstHomeSecondData(_ currentState: State) -> Observable<Mutation> {
        
        return HomeAPI.getSecondHomeData()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var sections = currentState.sections
                
                data.recommend.forEach {
                    
                    let item = $0.perfumeList.map { HomeSectionItem.recommendCell($0, $0.id, UUID()) }
                    
                    sections.append(HomeSection.recommendSection(header: $0.title, items: item))
                }
                return .just(.setSections(sections))
            }
    }
}
    
