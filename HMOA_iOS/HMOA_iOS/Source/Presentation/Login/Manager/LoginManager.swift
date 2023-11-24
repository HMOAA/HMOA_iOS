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
    
    var isLogin: Observable<Bool> {
        return tokenSubject
            .flatMap{ token -> Observable<Bool> in
                guard token != nil else { return .just(false) }
                return .just(true)
            }
    }
    
    var isInApp: Observable<Bool> {
        return loginStateSubject
            .map { state -> Bool in
                switch state {
                case .first: return false
                case .inApp: return true
                }
            }
    }
    
    
    private init () { }
    
}
