//
//  Int++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/09.
//

import Foundation

extension Int {

    func numberFormatterToWon() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return "₩" + numberFormatter.string(from: NSNumber(value: self))! + "~"
    }
    
    /// 나이로 태어난 년도 구하는 함수
    func ageToYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale(identifier: "ko")
        
        let year = dateFormatter.string(from: Date())
        
        return String(Int(year)! - self + 1)
    }
}
