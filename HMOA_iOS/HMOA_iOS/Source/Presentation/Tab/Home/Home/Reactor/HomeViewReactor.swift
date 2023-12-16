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
        case settingIsLogin(Bool)
        case postFcmToken
        case deleteFcmToken
    }
    
    enum Mutation {
        case setSelectedPerfumeId(IndexPath?)
        case setSections([HomeSection])
        case setPagination(Bool)
        case setIsPushAlarm(Bool)
        case setIsTapBell(Bool)
        case setUserSetting(Bool?)
        case success
        case setIsLogin(Bool)
    }
    
    struct State {
        var sections: [HomeSection] = []
        var selectedPerfumeId: Int?
        var isPaging: Bool = false
        var isPushAlarm: Bool? = nil
        var isTapBell: Bool = false
        var isPushSettiong: Bool = false
        var isUserSetting: Bool? = UserDefaults.standard.object(forKey: "alarm") as? Bool
        var isLogin: Bool? = nil
    }
    
    init() { self.initialState = State() }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return HomeViewReactor.reqeustHomeFirstData()
            
        case .itemSelected(let indexPath):
            return .concat([
                .just(.setSelectedPerfumeId(indexPath)),
                .just(.setSelectedPerfumeId(nil))
            ])
            
        case .scrollCollectionView:
            return .concat([
                HomeViewReactor.requstHomeSecondData(currentState),
                .just(.setPagination(true))
            ])
        
            //TODO: FCM 토큰 삭제, 토큰 보내기
        case .didTapBellButton:
            return .concat([
                .just(.setIsTapBell(true)),
                .just(.setIsTapBell(false))
                ])
            
        case .settingAlarmAuthorization(let isPush):
            return .just(.setIsPushAlarm(isPush))
            
        case .settingIsUserSetting(let setting):
            return .just(.setUserSetting(setting))
            
        case .postFcmToken:
            return postFcmToken()
            
        case .deleteFcmToken:
            return deleteFcmToken()
            
        case .settingIsLogin(let isLogin):
            return .just(.setIsLogin(isLogin))
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
            
        case .success:
            break
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
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
                let recommend = data.firstMenu
                
                sections.append(homeTopSection)
                
                let item = recommend.perfumeList.map { HomeSectionItem.recommendCell($0, 1)}
                
                sections.append(HomeSection.recommendSection(header: recommend.title, items: item, 0))
                
                return .just(.setSections(sections))
            }
    }
    
    
    static func requstHomeSecondData(_ currentState: State) -> Observable<Mutation> {
        
        return HomeAPI.getSecondHomeData()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var sections = currentState.sections
                var listIndex = 1
                data.forEach {
                    let item = $0.perfumeList.map { HomeSectionItem.recommendCell($0, listIndex) }
                    
                    sections.append(HomeSection.recommendSection(header: $0.title, items: item, listIndex))
                    listIndex += 1
                }
                return .just(.setSections(sections))
            }
    }
    
    func postFcmToken() -> Observable<Mutation> {
        guard let fcmToken = try? LoginManager.shared.fcmTokenSubject.value()! else { return .empty() }
        
        return PushAlarmAPI.postFcmToken(["fcmToken": fcmToken])
            .catch { _ in .empty() }
            .map { _ in .success }
        
    }
    
    func deleteFcmToken() -> Observable<Mutation> {
        return PushAlarmAPI.deleteFcmToken()
            .catch { _ in .empty() }
            .map { _ in .success }
    }
}
    
