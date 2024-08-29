//
//  HBTIOrderDividingLineView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/28/24.
//

import UIKit

final class HBTIOrderDividingLineView: UIView {
    
    private var dividingColor: UIColor
    
    init(color: UIColor) {
        self.dividingColor = color
        super.init(frame: .zero)
        setupUI()
    }
    
    init(frame: CGRect, color: UIColor) {
        self.dividingColor = color
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = dividingColor
    }
}
