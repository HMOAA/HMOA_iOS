//
//  HBTIAddressView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class HBTIAddressView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("배송지", font: .pretendard_bold, size: 18, color: .black)
    }
    
    let saveDeliveryInfoButton = UIButton().makeUnderLineButton(text: "배송지를 입력해주세요", textColor: .black)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         titleLabel,
         saveDeliveryInfoButton
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        saveDeliveryInfoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
    }
}
