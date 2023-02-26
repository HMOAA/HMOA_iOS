//
//  ChocieEmailViewModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/20.
//

import UIKit

import RxSwift

class ChocieEmailViewModel {
    
    let selectedIndex = PublishSubject<Int>()
    let emailOb: Observable<[String]>
    let emailData = ["직접입력", "naver.com", "gamil.com", "daum.net", "hanmail.net", "nate.com"]
    
    init() {
        emailOb = Observable.just(emailData)
    }
}
 
