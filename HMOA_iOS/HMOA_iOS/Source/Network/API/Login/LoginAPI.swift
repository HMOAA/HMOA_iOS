//
//  LoginAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

import Alamofire
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift

final class LoginAPI {
    
    //Token 보내기
    static func postAccessToken(params: [String: String], _ type: LoginAddress) -> Observable<Token> {
        guard let data = try? JSONSerialization.data(
                    withJSONObject: params,
                    options: .prettyPrinted)
                
        else { return Observable.error(NetworkError.invalidParameters) }
        return networking(
            urlStr: type.url,
            method: .post,
            data: data,
            model: Token.self)
    }
    
    //자동 로그인 토큰 받기
    static func autoLoginToken(_ completion: @escaping(DataResponse<Token, AFError>) -> Void) {
        let url = URL(string: baseURL.url + LoginAddress.remebered.url)
        guard let rememberToken = try? LoginManager.shared.tokenSubject.value()?.rememberedToken
        else { return }
        let params = ["rememberedToken": rememberToken]
        
        guard let data = try? JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted
        ) else { return }
                
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.method = .post
        request.httpBody = data
        print(request)
        
        AF.request(request, interceptor: AppRequestInterceptor())
            .responseDecodable(of: Token.self) { response in
                completion(response)
            }
    }
    
    //카카오 로그인 OAuThToken 받기
    static func kakaoLogin() -> Observable<OAuthToken>{
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
        } else { return Observable.empty() }
    }
}
