//
//  StartViewModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/24.
//

import UIKit

import RxSwift

class StartViewModel {
    
    let manButtonOb = BehaviorSubject<Bool>(value: false)
    let womanButtonOb = BehaviorSubject<Bool>(value: false)
    let yearTextOb = PublishSubject<String>()
    
    var isComplete: Observable<Bool> {
        return Observable.combineLatest(manButtonOb, womanButtonOb, yearTextOb, resultSelector: { man, woman, year in
            return man || woman && year != "선택"
        })
    }
    
    func presentSelectYear() -> ChoiceYearViewController {
        let vc = ChoiceYearViewController()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        return vc
    }
    
}
