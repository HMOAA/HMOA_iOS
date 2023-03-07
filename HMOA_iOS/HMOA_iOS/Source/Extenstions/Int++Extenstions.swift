//
//  Int++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/07.
//

import Foundation

extension Int {
    
    func numberFormatterToWon() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return "₩" + numberFormatter.string(from: NSNumber(value: self))! + "~"
    }
}
