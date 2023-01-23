//
//  UITextField++Extenstion.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/23.
//

import UIKit

extension UITextField {
    
    func setPlaceholder(color: UIColor) {
            guard let string = self.placeholder else {
                return
            }
            attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
        }
    
    func addLeftPadding() {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        self.leftViewMode = .always
    }
}
