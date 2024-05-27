//
//  LoginManager.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/16.
//

import UIKit

import RxSwift

final class LoginManager {
    
    static let shared = LoginManager()
    var disposeBag = DisposeBag()
    let tokenSubject: BehaviorSubject<Token?> = BehaviorSubject<Token?>(value: nil)
    let loginStateSubject: BehaviorSubject<LoginState> = BehaviorSubject(value: .first)
    let fcmTokenSubject: BehaviorSubject<String?> = BehaviorSubject(value: "")
    let isPushAlarmAuthorization: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let isUserSettingAlarm: BehaviorSubject<Bool?> = BehaviorSubject(value: UserDefaults.standard.object(forKey: "alarm") as? Bool)
    let isLogin: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    
    var isInApp: Observable<Bool> {
        return loginStateSubject
            .map { state -> Bool in
                switch state {
                case .first: return false
                case .inApp: return true
                }
            }
    }
    
    private init () {
        tokenSubject
            .map { $0?.existedMember == true }
            .bind(to: isLogin)
            .disposed(by: disposeBag)
    }
    
}
