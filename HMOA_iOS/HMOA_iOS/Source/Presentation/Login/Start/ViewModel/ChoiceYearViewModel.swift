//
//  ChoiceYearViewModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/24.
//

import UIKit

import RxSwift

class ChoiceYearViewModel {
    
    let selectedIndex = PublishSubject<Int>()
    let years = Year().year
    let yearOb: Observable<[String]>
    
    init() {
        yearOb = Observable.just(years)
    }
}
