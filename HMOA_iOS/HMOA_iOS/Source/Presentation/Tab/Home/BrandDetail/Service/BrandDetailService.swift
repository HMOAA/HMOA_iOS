//
//  BrandDetailService.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/19/23.
//

import Foundation

import RxSwift

enum BrandDetailEvent {
    case setIsLikedPerfume(BrandPerfume)
}

protocol BrandDetailProtocol {
    var event: PublishSubject<BrandDetailEvent> { get }
    
    func setIsLikedPerfume(to brandPerfume: BrandPerfume) -> Observable<BrandPerfume>
}

class BrandDetailService: BrandDetailProtocol {
    var event = PublishSubject<BrandDetailEvent>()
    
    func setIsLikedPerfume(to brandPerfume: BrandPerfume) -> Observable<BrandPerfume> {
        event.onNext(.setIsLikedPerfume(brandPerfume))
        return .just(brandPerfume)
    }
}
