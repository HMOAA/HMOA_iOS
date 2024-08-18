//
//  HBTIQuantitySelectButton.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import Then
import SnapKit

final class HBTIQuantitySelectButton: UIButton {
    
    // MARK: - UI Components
    
    private let checkBoxImageView = UIImageView()
    
    let quantityLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
    }
    
    override var isSelected: Bool {
        didSet {
            layer.backgroundColor = isSelected
                ? #colorLiteral(red: 0.3913987577, green: 0.3913987279, blue: 0.3913987577, alpha: 1)
                : #colorLiteral(red: 0.9626654983, green: 0.9626654983, blue: 0.9626654983, alpha: 1)
            checkBoxImageView.image = isSelected
                ? UIImage(named: "checkBoxSelected")
                : UIImage(named: "checkBoxNotSelected")
            quantityLabel.textColor = isSelected
                ? .white
                : .black
        }
    }
    
    // MARK: - LifeCycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
    
    private func setUI() {
        isSelected = false
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         checkBoxImageView,
         quantityLabel
        ].forEach(addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        checkBoxImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(19)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(18)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(19)
            $0.centerY.equalToSuperview()
        }
    }
}
