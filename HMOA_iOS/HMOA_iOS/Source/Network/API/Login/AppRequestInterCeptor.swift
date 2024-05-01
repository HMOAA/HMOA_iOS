//
//  AppRequestInterCeptor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/06/07.
//

import Foundation
import Alamofire
import RxSwift

final class AppRequestInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()  // RxSwift의 메모리 관리를 위한 Dispose Bag
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        // tokenSubject에서 토큰을 비동기적으로 가져오기
        LoginManager.shared.tokenSubject
            .take(1)  // 첫 번째 값을 가져오고 구독을 종료
            .subscribe(onNext: { token in
                var urlRequest = urlRequest
                if let authToken = token?.authToken {
                    urlRequest.setValue(authToken, forHTTPHeaderField: "X-AUTH-TOKEN")
                }
                print(" adpat \(urlRequest)")
                completion(.success(urlRequest))
            }, onError: { error in
                print("Error fetching token: \(error)")
                completion(.failure(error))
            })
            .disposed(by: disposeBag)
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        if let statusCode = error.asAFError?.responseCode, statusCode == 409 {
            completion(.doNotRetry)
            return
        }
        
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        LoginAPI.autoLoginToken { response in
            switch response.result {
            case .success(var token):
                token.existedMember = true
                LoginManager.shared.tokenSubject.onNext(token)
                KeychainManager.create(token: token)
                print("토큰 갱신 성공")
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
