//
//  LoginReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/06.
//

import UIKit

import ReactorKit
import RxSwift
import AuthenticationServices

class LoginReactor: NSObject, Reactor {
    let initialState: State
    
    private let appleLoginResultSubject = PublishSubject<String?>()
    let disposeBag = DisposeBag()
    
    enum Action {
        case didTapGoogleLoginButton
        case didTapAppleLoginButton
        case didTapKakaoLoginButton
        case didTapNoLoginButton
        case didTapXButton
    }

    enum Mutation {
        case setPresentTabBar(Bool)
        case setPushStartVC(Bool)
        case setSignInGoogle(Bool)
        case setKakaoToken(Token?)
        case setIsDismiss(Bool)
        case setAppleToken(Token?)
    }
    
    struct State {
        var isSignInGoogle: Bool = false
        var isPushStartVC: Bool = false
        var isPresentTabBar: Bool = false
        var kakaoToken: Token? = nil
        var loginState: LoginState
        var isDismiss: Bool = false
        var appleToken: Token? = nil
    }
    
    init(_ loginState: LoginState) {
        initialState = State(loginState: loginState)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNoLoginButton:
            return .concat([
                .just(.setPresentTabBar(true)),
                .just(.setPresentTabBar(false))
                      ])
        case .didTapGoogleLoginButton:
            return .concat([
                .just(.setSignInGoogle(true)),
                .just(.setSignInGoogle(false))
                      ])
        case .didTapAppleLoginButton:
            signInApple()
            return setAppleLoginToken()
        case .didTapKakaoLoginButton:
            return setKakaoToken()
            
        case .didTapXButton:
            return .concat([
                .just(.setIsDismiss(true)),
                .just(.setIsDismiss(false))
            ])
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSignInGoogle(let isSignIn):
            state.isSignInGoogle = isSignIn
        case .setPresentTabBar(let isPresent):
            state.isPresentTabBar = isPresent
        case .setPushStartVC(let isPush):
            state.isPushStartVC = isPush
        case .setKakaoToken(let token):
            state.kakaoToken = token
        case .setIsDismiss(let isDismiss):
            state.isDismiss = isDismiss
        case .setAppleToken(let token):
            state.appleToken = token
        }
        
        return state
    }
}

extension LoginReactor: ASAuthorizationControllerDelegate {
    
    func setKakaoToken() -> Observable<Mutation> {
        return LoginAPI.kakaoLogin()
            .flatMap { oAuthToken -> Observable<Mutation> in
                return LoginAPI.postAccessToken(params: ["token": oAuthToken.accessToken], .kakao)
                    .flatMap { token -> Observable<Mutation> in
                        return .concat([
                            .just(.setKakaoToken(token)),
                            .just(.setKakaoToken(nil))
                        ])
                    }
            }
    }
    
    func signInApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
               let authorizationCode = appleIDCredential.authorizationCode,
               let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) {
                appleLoginResultSubject.onNext(authorizationCodeString)
            } else {
                appleLoginResultSubject.onNext(nil)
            }
        }
    }
    
    // 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
        appleLoginResultSubject.onError(error)
    }
    
    func setAppleLoginToken() -> Observable<Mutation> {
        return appleLoginResultSubject
            .flatMap { authorizationToken -> Observable<Mutation> in
                guard let authorizationToken = authorizationToken else { return .empty() }
                return LoginAPI.postAccessToken(params: ["token": authorizationToken], .apple)
                    .catch { _ in .empty() }
                    .map { .setAppleToken($0) }
            }
    }
}
