//
//  UserYearService.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/08.
//

import RxSwift

enum UserYearEvent {
    case selectedYear(content: String)
}

protocol UserYearServiceProtocol {
    var event: PublishSubject<UserYearEvent> { get }
    
    func selectedYear(to year: String) -> Observable<String>
}

class UserYearService: UserYearServiceProtocol {
    
    let event = PublishSubject<UserYearEvent>()
    
    func selectedYear(to year: String) -> Observable<String> {
        event.onNext(.selectedYear(content: year))
        return .just(year)
    }
}


