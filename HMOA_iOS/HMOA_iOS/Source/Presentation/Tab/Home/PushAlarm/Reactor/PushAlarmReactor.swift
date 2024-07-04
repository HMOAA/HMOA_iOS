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
        case viewDidLoad
    }
    
    enum Mutation {
        case setPushAlarmList([PushAlarmItem])
    }
    
    struct State {
        var pushAlarmItems: [PushAlarmItem] = []
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setUpAlarmList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPushAlarmList(let items):
            state.pushAlarmItems = items
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
}
