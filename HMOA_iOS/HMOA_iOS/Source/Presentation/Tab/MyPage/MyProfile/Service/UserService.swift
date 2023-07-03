//
//  UserService.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/07.
//

import RxSwift

enum UserEvent {
    case updateNickname(content: String)
    case updateImage(content: UIImage?)
    case updateUserAge(content: Int)
    case updateUserSex(content: Bool)
}

protocol UserServiceProtocol {
    var event: PublishSubject<UserEvent> { get }
    
    func updateUserNickname(to nickname: String) -> Observable<String>
    
    func updateUserImage(to image: UIImage?) -> Observable<UIImage?>
    
    func updateUserAge(to year: String) -> Observable<Int>
    
    func updateUserSex(to sex: Bool) -> Observable<Bool>
}


class UserService: UserServiceProtocol {
    
    let event = PublishSubject<UserEvent>()
    
    func updateUserNickname(to nickname: String) -> Observable<String> {
        event.onNext(.updateNickname(content: nickname))
        return .just(nickname)
    }
    
    func updateUserImage(to image: UIImage?) -> Observable<UIImage?> {
        event.onNext(.updateImage(content: image))
        return .just(image)
    }
    
    
    func updateUserAge(to year: String) -> Observable<Int> {
        let age = 2024 - Int(year)!
        event.onNext(.updateUserAge(content: age))
        return .just(age)
    }
    
    func updateUserSex(to sex: Bool) -> Observable<Bool> {
        event.onNext(.updateUserSex(content: sex))
        return .just(sex)
    }
}


