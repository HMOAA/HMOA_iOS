//
//  LoginAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift

final class LoginAPI {
    
    //googleToken 보내기
    static func postAccessToken(params: [String: String], _ type: LoginAddress) -> Observable<Token> {
        print(params)
        guard let data = try? JSONSerialization.data(
                    withJSONObject: params,
                    options: .prettyPrinted)
                
        else { return Observable.error(NetworkError.invalidParameters)}
        
        return networking(
            urlStr: type.url,
            method: .post,
            data: data,
            model: Token.self)
    }
    
    static func kakaoLogin() -> Observable<OAuthToken>{
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
        } else { return Observable.empty() }
    }
}
