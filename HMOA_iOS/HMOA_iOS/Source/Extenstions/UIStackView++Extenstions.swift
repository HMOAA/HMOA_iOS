//
//  UIStackView++Extenstions.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/27.
//

import UIKit

extension UIStackView {
    
    func setStackViewUI(spacing: CGFloat, axis: NSLayoutConstraint.Axis = .vertical) {
    
        self.spacing = spacing
        self.axis = axis
    }
}

