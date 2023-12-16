//
//  UITextView++Extension.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/28/23.
//

import Foundation
import UIKit

extension UITextView {
    
    // textview height 변경 시 text가 top에 붙으므로 centerY 해 줌
    func alignCenterYText() {
        let textViewHeight = self.bounds.size.height
        let contentHeight = self.sizeThatFits(self.bounds.size).height
        let topInset = max(0, (textViewHeight - contentHeight) / 2)
        self.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
}
