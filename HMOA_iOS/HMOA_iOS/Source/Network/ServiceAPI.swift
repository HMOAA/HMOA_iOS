//
//  ServiceAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import Alamofire
import GoogleSignIn
import RxSwift

enum NetworkError: Error {
    case invalidParameters
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
}


public func networking<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    data: Data?,
    model: T.Type) -> Observable<T> {
    
    return Observable<T>.create { observer in

        // TODO: 도메인 생성되면 baseURL로 따로 빼서 정의
        guard let url = URL(string: baseURL.url + urlStr) else {
            observer.onError(NetworkError.invalidURL)
            return Disposables.create()
        }
        var reqeust = URLRequest(url: url)
        reqeust.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
        reqeust.httpBody = data
        reqeust.method = method

        AF.request(reqeust, interceptor: AppRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: model.self) { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
        
        return Disposables.create()
    }
}

public func uploadNetworking<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    data: Data,
    model: T.Type) -> Observable<T> {
        
    return Observable.create { observer in
        guard let url = URL(string: baseURL.url + urlStr) else {
            observer.onError(NetworkError.invalidURL)
            return Disposables.create()
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: "profileImage.jpeg", mimeType: "image/jpeg")
        },to: url, interceptor: AppRequestInterceptor())
        .validate(statusCode: 200..<300)
        .responseDecodable(of: model.self) { response in
            switch response.result {
            case .success(let result):
                observer.onNext(result)
                observer.onCompleted()
            case .failure(let error):
                print("Error: \(error)")
                observer.onError(error)
            }
        }
                
        return Disposables.create()
    }
}


