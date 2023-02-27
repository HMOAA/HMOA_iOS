//
//  PaddingLabel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/17.
//
import Foundation
import UIKit

class PaddingLabel: UILabel {
    
    var topPadding: CGFloat = 0.0
    var leftPadding: CGFloat = 0.0
    var bottomPadding: CGFloat = 0.0
    var rightPadding: CGFloat = 0.0
    
    func setPadding(padding: UIEdgeInsets) {
        self.topPadding = padding.top
        self.leftPadding = padding.left
        self.bottomPadding = padding.bottom
        self.rightPadding = padding.right
    }
    
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.leftPadding + self.rightPadding
        contentSize.height += self.topPadding + self.bottomPadding
        return contentSize
    }
}
