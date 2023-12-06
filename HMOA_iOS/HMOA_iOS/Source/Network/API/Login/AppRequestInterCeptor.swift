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
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let token = try? LoginManager.shared.tokenSubject.value() else{
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(token.authToken, forHTTPHeaderField: "X-AUTH-TOKEN")
        completion(.success(urlRequest))
        print(" adpat \(urlRequest)")
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
            print("response \(response.result)")
            switch response.result {
            case .success(let token):
                LoginManager.shared.tokenSubject.onNext(token)
                KeychainManager.create(token: token)
                print("성공")
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
