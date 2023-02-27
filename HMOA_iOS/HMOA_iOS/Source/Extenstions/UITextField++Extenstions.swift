//
//  UITextField++Extenstion.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/23.
//

import UIKit
import SnapKit

extension UITextField {
    
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
    
    func addLeftPadding(_ width: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0))
        self.leftViewMode = .always
    }
    
    func setTextFieldUI(_ placeholder: String, leftPadding: CGFloat, font: Fonts, isCapsule: Bool = true) {
        self.font = .customFont(font, 14)
        self.placeholder = placeholder
        self.addLeftPadding(leftPadding)
        self.setPlaceholder(color: .customColor(.gray2))
        
        if isCapsule {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.customColor(.gray1).cgColor
        }
    }
}
