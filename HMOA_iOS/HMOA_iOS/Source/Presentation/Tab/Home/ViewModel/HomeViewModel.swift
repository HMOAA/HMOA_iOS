//
//  HomeViewModel.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/18.
//

import UIKit

class HomeViewModel {
    
    var newsIndex = 0 {
        didSet {
            if newsIndex < 0 {
                newsIndex = 0
            } else if newsIndex > 9 {
                newsIndex = 9
            }
        }
    }
    
    func newsButtonClicked(_ bool: Bool) {
        if bool {
            newsIndex -= 1
        } else {
            newsIndex += 1
        }
    }
}
