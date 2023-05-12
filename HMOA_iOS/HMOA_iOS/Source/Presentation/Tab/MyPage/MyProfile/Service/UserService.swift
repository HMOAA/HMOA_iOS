//
//  UserService.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/07.
//

import RxSwift

enum UserEvent {
    case updateNickname(content: String)
    case updateImage(content: UIImage)
}

protocol UserServiceProtocol {
    var event: PublishSubject<UserEvent> { get }
    
    func updateUserNickname(to nickname: String) -> Observable<String>
    
    func updateUserImage(to image: UIImage) -> Observable<UIImage>
}


class UserService: UserServiceProtocol {
    
    let event = PublishSubject<UserEvent>()
    
    func updateUserNickname(to nickname: String) -> Observable<String> {
        event.onNext(.updateNickname(content: nickname))
        return .just(nickname)
    }
    
    func updateUserImage(to image: UIImage) -> Observable<UIImage> {
        event.onNext(.updateImage(content: image))
        return .just(image)
    }
}


