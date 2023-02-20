//
//  HomeViewReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import ReactorKit
import RxCocoa

final class HomeViewReactor: Reactor {
    typealias State = HomeViewReactor.state
    
    let viewModel = HomeViewModel()
    
    enum Action {
        case viewDidLoad
        case itemSelected(IndexPath)
    }
    
    enum Mutation {
        case setHomeTop
        case setHomeFirst
        case setHomeSecond
        case setHomeWatch
        case setIsPresentDetailVC(Bool)
    }
    
    struct state {
        var homeTopSection = HomeSection.Model(
            model: .homeTop,
            items: []
        )
        
        var homeFirstSection = HomeSection.Model(
            model: .homeFirst,
            items: []
        )
        
        var homeSecondSection = HomeSection.Model(
            model: .homeSecond,
            items: []
        )
        
        var homeWatchSection = HomeSection.Model(
            model: .homeWatch,
            items: []
        )
        
        var isPresentDetailVC: Bool = false
    }
    
    var initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                [Observable<Mutation>.just(.setHomeTop),
                 Observable<Mutation>.just(.setHomeFirst),
                 Observable<Mutation>.just(.setHomeSecond),
                 Observable<Mutation>.just(.setHomeWatch)
                ]
            )
        case .itemSelected:
            return .concat([
                Observable<Mutation>.just(.setIsPresentDetailVC(true)),
                Observable<Mutation>.just(.setIsPresentDetailVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setHomeTop:
            let item = HomeSection.Item.photo(UIImage(named: "jomalon")!)
            let sectionModel = HomeSection.Model(model: .homeTop, items: [item])
            
            state.homeTopSection = sectionModel
        case .setHomeFirst:
            
            let item = viewModel.perfumess.map(HomeSection.Item.Info)
            let sectionModel = HomeSection.Model(model: .homeFirst, items: item)
            state.homeFirstSection = sectionModel
        case .setHomeSecond:
            let item = viewModel.perfumess.map(HomeSection.Item.Info)
            let sectionModel = HomeSection.Model(model: .homeSecond, items: item)
            state.homeSecondSection = sectionModel
        case .setHomeWatch:
            let item = viewModel.perfumess.map(HomeSection.Item.Info)
            let sectionModel = HomeSection.Model(model: .homeWatch, items: item)
            state.homeWatchSection = sectionModel
        case .setIsPresentDetailVC(let isPresent):
            state.isPresentDetailVC = isPresent
        }
        
        return state
        
    }
    
}
