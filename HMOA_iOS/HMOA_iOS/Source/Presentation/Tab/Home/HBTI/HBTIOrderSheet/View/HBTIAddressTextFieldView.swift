//
//  HBTIAddressTextFieldView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then

final class HBTIAddressTextFieldView: UIView {
    
    // MARK: UI Components
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set AddView

    private func setAddView() {
        [
         
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        
    }
}
