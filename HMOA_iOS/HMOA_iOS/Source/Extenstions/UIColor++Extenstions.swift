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
    case textGrayColor
    case gray1
    case gray2
    case gray3
    case gray4
    case black
    case blue
    case red
    case white
    case HPediaCellColor
    case brandBorderColor
    case banerLabelColor
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
        case .textGrayColor:
            return #colorLiteral(red: 0.611764729, green: 0.611764729, blue: 0.611764729, alpha: 1)
        case .gray1:
            return #colorLiteral(red: 0.9568627477, green: 0.9568627477, blue: 0.9568627477, alpha: 1)
        case .gray2:
            return #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
        case .gray3:
            return #colorLiteral(red: 0.611764729, green: 0.611764729, blue: 0.611764729, alpha: 1)
        case .gray4:
            return #colorLiteral(red: 0.2549019456, green: 0.2549019456, blue: 0.2549019456, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0.2517642379, green: 0.6613503695, blue: 0.9509820342, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.9553416371, green: 0.4574130774, blue: 0.4385059178, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .HPediaCellColor:
            return #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
        case .brandBorderColor:
            return #colorLiteral(red: 0.7810429931, green: 0.7810428739, blue: 0.7810428739, alpha: 1)
        case .banerLabelColor:
            return #colorLiteral(red: 0.4678141475, green: 0.4678141475, blue: 0.4678141475, alpha: 1)
        }
    }
}

