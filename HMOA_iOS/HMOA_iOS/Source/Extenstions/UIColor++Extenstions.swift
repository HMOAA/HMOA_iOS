//
//  UIColor++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

enum Colors {
    case tabbarColor
    case searchBarColor
    case labelGrayColor
}

extension UIColor {
    static func customColor(_ color: Colors) -> UIColor {
        switch color {
        case .tabbarColor:
            return #colorLiteral(red: 0.3999999464, green: 0.3999999464, blue: 0.3999999464, alpha: 1)
        case .searchBarColor:
            return #colorLiteral(red: 0.8509805202, green: 0.8509804606, blue: 0.8509804606, alpha: 1)
        case .labelGrayColor:
            return #colorLiteral(red: 0.5450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
        }
    }
}

