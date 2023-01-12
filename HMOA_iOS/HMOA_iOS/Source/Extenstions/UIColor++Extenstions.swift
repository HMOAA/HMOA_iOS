//
//  UIColor++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

enum Colors {
    case tabbarColor
}

extension UIColor {
    static func customColor(_ color: Colors) -> UIColor {
        switch color {
        case .tabbarColor:
            return #colorLiteral(red: 0.3999999464, green: 0.3999999464, blue: 0.3999999464, alpha: 1)
        }
    }
}
