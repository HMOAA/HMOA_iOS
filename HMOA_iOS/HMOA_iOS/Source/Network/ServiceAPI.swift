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
    model: T.Type,
    query: [String: Any]? = nil) -> Observable<T> {
    
    return Observable<T>.create { observer in

        //get Parameter를 위한 url Component
        guard var urlComponents = URLComponents(string: baseURL.url + urlStr) else {
            observer.onError(NetworkError.invalidURL)
            return Disposables.create()
        }
        
        //parameter 추가
        if let parameters = query {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
               
        // URL 생성 실패 처리
        guard let url = urlComponents.url else {
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
    imageData: [Data]?,
    imageFileName: String?,
    parameter: [String: Any]?,
    model: T.Type) -> Observable<T> {
        
        return Observable.create { observer in
            guard let url = URL(string: baseURL.url + urlStr) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                // text parmater가 있을 경우 추가
                if let parameter = parameter {
                    for (key, value) in parameter {
                        if let intArray = value as? [Int] {
                            // [Int] 배열 처리
                            for intItem in intArray {
                                if let data = "\(intItem)".data(using: .utf8) {
                                    multipartFormData.append(data, withName: key + "[]")
                                }
                            }
                        } else {
                            // text 타입 처리
                            let valueStr = String(describing: value)
                            if let data = valueStr.data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                }
                // 이미지 데이터가 있을 경우에만 추가
                if let imageDatas = imageData, let imageFileName = imageFileName {
                    for (_, imageData) in imageDatas.enumerated() {
                        multipartFormData.append(imageData, withName: "image", fileName: imageFileName, mimeType: "image/jpeg")
                    }
                }
            }, to: url, interceptor: AppRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: model.self) { response in
                switch response.result {
                case .success(let result):
                    observer.onNext(result)
                    observer.onCompleted()
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }

