//
//  UIView++Extensions.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/11/24.
//

import UIKit

extension UIView {
    
    // 텍스트필드에서 returnKey 입력 시 다음 텍스트필드 이동
    func moveToNextTextField(currentTextField: UITextField, nextTextField: UITextField?) -> Bool {
        if let next = nextTextField {
            next.becomeFirstResponder()
        } else {
            currentTextField.resignFirstResponder()
        }
        return true
    }
}
