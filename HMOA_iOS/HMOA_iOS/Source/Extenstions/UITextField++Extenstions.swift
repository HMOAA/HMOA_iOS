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
    
    func addLeftPadding(_ width: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0))
        self.leftViewMode = .always
    }
    
    func setTextFieldUI(_ placeholder: String, leftPadding: CGFloat, isCapsule: Bool = true) {
        self.backgroundColor = .customColor(.searchBarColor)
        self.font = .customFont(.pretendard, 14)
        self.placeholder = placeholder
        self.addLeftPadding(leftPadding)
        self.setPlaceholder(color: .black)

        if isCapsule {
            self.snp.makeConstraints { make in
                make.height.equalTo(33)
            }
            
            self.layer.cornerRadius = 33 / 2
        }
        
        
    }
}
