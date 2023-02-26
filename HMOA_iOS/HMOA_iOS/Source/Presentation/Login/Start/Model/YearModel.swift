//
//  YearModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/24.
//

import Foundation

struct Year {
    var year = [String]()
    
    init() {
        for i in (1960...2016).reversed() {
            self.year.append("\(i)")
        }
    }
}
