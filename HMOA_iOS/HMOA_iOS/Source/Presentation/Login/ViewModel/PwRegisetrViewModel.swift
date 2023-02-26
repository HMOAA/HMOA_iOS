//
//  PwRegisetrViewModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/24.
//

import UIKit

import RxCocoa
import RxSwift

class PwRegisetrViewModel {
    
    let pwTextOb = PublishSubject<String>()
    let reConfirmPwTextOb = PublishSubject<String>()
    
    var moreThan8: Observable<Bool> {
        return pwTextOb.map { $0.count > 7}
    }
    
    var isSame: Observable<Bool> {
        return Observable.combineLatest(pwTextOb, reConfirmPwTextOb, moreThan8, resultSelector:{ pw, rePw, more in
            return !pw.isEmpty && pw == rePw && more
        })
    }
}
