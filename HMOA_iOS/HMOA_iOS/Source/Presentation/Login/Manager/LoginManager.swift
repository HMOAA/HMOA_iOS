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
    
    let tokenSubject:BehaviorSubject<Token?> = BehaviorSubject<Token?>(value: nil)
    private init () { }
    
}
