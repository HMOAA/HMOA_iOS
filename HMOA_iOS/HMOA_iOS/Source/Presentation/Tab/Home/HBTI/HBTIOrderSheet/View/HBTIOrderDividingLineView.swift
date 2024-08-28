//
//  HBTIOrderDividingLineView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/28/24.
//

import UIKit

final class HBTIOrderDividingLineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black
    }
}
