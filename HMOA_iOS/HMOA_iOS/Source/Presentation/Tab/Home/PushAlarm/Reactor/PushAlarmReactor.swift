//
//  NotificationReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/17/24.
//

import Foundation
import ReactorKit
import RxSwift

class PushAlarmReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewWillAppear
        case didTapAlarmCell(IndexPath)
        case didTapBellButton
        case settingAlarmAuthorization(Bool)
        case settingIsUserSetting(Bool?)
        case networkingFcmTokenAPI(Bool)
    }
    
    enum Mutation {
        case setPushAlarmList([PushAlarmItem])
        case setSelectedAlarm(IndexPath?)
        case setIsPushAlarm(Bool)
        case setIsUserSetting(Bool?)
        case setIsOnBellButton(Bool)
        case setIsTapBell(Bool)
        case success
    }
    
    struct State {
        var pushAlarmItems: [PushAlarmItem] = []
        var selectedAlarm: PushAlarm? = nil
        var isOnBellButton: Bool? = nil
        var isPushSetting: Bool = false
        var isUserSetting: Bool? = UserDefaults.standard.value(forKey: "alarm") as? Bool
        var isTapBell: Bool = false
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return setUpAlarmList()
            
        case .didTapAlarmCell(let indexPath):
            return .concat([
                .just(.setSelectedAlarm(indexPath)),
                .just(.setSelectedAlarm(nil)),
                setAlarmRead(indexPath)
            ])
            
        case .didTapBellButton:
            if currentState.isPushSetting {
                guard let currentBellState = currentState.isOnBellButton else { return .empty() }
                return .concat([
                    .just(.setIsOnBellButton(!currentBellState)),
                    saveOrDeleteFcmToken(!currentBellState)
                ])
            } else {
                return .concat([
                    .just(.setIsTapBell(true)),
                    .just(.setIsTapBell(false))
                ])
            }
            
        case .settingAlarmAuthorization(let setting):
            return .just(.setIsPushAlarm(setting))
            
        case .settingIsUserSetting(let setting):
            guard let setting = setting else { return .empty() }
            return .just(.setIsOnBellButton(setting))
            
        case .networkingFcmTokenAPI(let isOn):
            return saveOrDeleteFcmToken(isOn)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPushAlarmList(let items):
            state.pushAlarmItems = items
            
        case .setSelectedAlarm(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedAlarm = nil
                return state
            }
            
            let selectedAlarm = currentState.pushAlarmItems[indexPath.row].pushAlarm
            state.selectedAlarm = selectedAlarm
            
        case .setIsTapBell(let isTap):
            state.isTapBell = isTap
            
        case .setIsOnBellButton(let isOn):
            state.isOnBellButton = isOn
            
        case .setIsPushAlarm(let setting):
            state.isPushSetting = setting
            if !setting {
                state.isOnBellButton = false
            }
            
        case .setIsUserSetting(let setting):
            state.isUserSetting = setting
            
        case .success:
            break
            
        }
        return state
    }
}

extension PushAlarmReactor {
    func setUpAlarmList() -> Observable<Mutation> {
        return PushAlarmAPI.fetchAlarmList()
            .catch { _ in .empty() }
            .flatMap { pushAlarmListData -> Observable<Mutation> in
                let listData = pushAlarmListData.data
                    .map { pushAlarmData in
                        let pushAlarm = PushAlarm(
                            ID: pushAlarmData.ID,
                            senderProfileImage: pushAlarmData.senderProfileImage,
                            category: pushAlarmData.category,
                            content: pushAlarmData.content,
                            pushDate: pushAlarmData.pushDate,
                            deeplink: pushAlarmData.deeplink,
                            isRead: pushAlarmData.isRead
                        )
                        return PushAlarmItem.pushAlarm(pushAlarm)
                    }
                return .just(.setPushAlarmList(listData))
            }
    }
    
    func setAlarmRead(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let selectedAlarm = currentState.pushAlarmItems[indexPath.row].pushAlarm,
              !selectedAlarm.isRead else {
            return .empty()
        }
        
        return PushAlarmAPI.putAlarmRead(ID: selectedAlarm.ID)
            .catch { _ in .empty() }
            .map { _ in .success }
    }
    
    func saveOrDeleteFcmToken(_ isOn: Bool) -> Observable<Mutation> {
        if isOn {
            guard let fcmToken = try? LoginManager.shared.fcmTokenSubject.value()! else { return .empty() }
            
            return PushAlarmAPI.postFcmToken(["fcmtoken": fcmToken])
                .catch { _ in .empty() }
                .map { _ in .success }
            
        } else {
            return PushAlarmAPI.deleteFcmToken()
                .catch { _ in .empty() }
                .map { _ in .success }
        }
    }
}
