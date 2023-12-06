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
        case scrollCollectionView
        case didTapBellButton
        case settingAlarmAuthorization(Bool)
        case settingIsUserSetting(Bool?)
    }
    
    enum Mutation {
        case setSelectedPerfumeId(IndexPath?)
        case setSections([HomeSection])
        case setPagination(Bool)
        case setIsPushAlarm(Bool)
        case setIsTapBell(Bool)
        case setUserSetting(Bool?)
    }
    
    struct State {
        var sections: [HomeSection] = []
        var selectedPerfumeId: Int?
        var isPaging: Bool = false
        var isPushAlarm: Bool? = nil
        var isTapBell: Bool = false
        var isPushSettiong: Bool = false
        var isUserSetting: Bool? = UserDefaults.standard.object(forKey: "alarm") as? Bool
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
            
        case .scrollCollectionView:
            return .concat([
                HomeViewReactor.requstHomeSecondData(currentState),
                .just(.setPagination(true))
            ])
        
            //TODO: FCM 토큰 삭제, 토큰 보내기
        case .didTapBellButton:
            return postFcmToken()
            
        case .settingAlarmAuthorization(let isPush):
            return .just(.setIsPushAlarm(isPush))
            
        case .settingIsUserSetting(let setting):
            return .just(.setUserSetting(setting))
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
            
        case .setPagination(let isPaging):
            state.isPaging = isPaging
            
        case .setSections(let sections):
            state.sections = sections
            
        case .setIsPushAlarm(let isPush):
            state.isPushSettiong = !isPush
            
            if let isAlarm = state.isUserSetting {
                state.isPushAlarm = isAlarm && isPush
            } else { state.isPushAlarm = isPush }
            
        case .setIsTapBell(let isTap):
            state.isTapBell = isTap
            
        case .setUserSetting(let setting):
            state.isUserSetting = setting
            state.isPushAlarm = setting
            UserDefaults.standard.set(setting, forKey: "alarm")
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
    
    func postFcmToken() -> Observable<Mutation> {
        // fcm 토큰 보내기
        return .concat([
            .just(.setIsTapBell(true)),
            .just(.setIsTapBell(false))
        ])
    }
}
    
