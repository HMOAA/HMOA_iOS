//
//  LoginManager.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/16.
//

import UIKit

final class LoginManager {
    
    static let shared = LoginManager()
    
    var googleToken: GoogleToken? = nil
    
    private init () { }
    
}
