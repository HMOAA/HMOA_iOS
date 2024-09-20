//
//  HBTIOrdererInfoView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/26/24.
//

import UIKit
import SnapKit
import Then

final class HBTIOrdererInfoView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("주문자 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let saveInfoButton = UIButton().then {
        let text = "작성한 정보 저장하기"
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.customFont(.pretendard_medium, 10),
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    
    private let nameLabel = UILabel().then {
        $0.setLabelUI("이름", font: .pretendard_medium, size: 12, color: .black)
    }
    
    private let nameTextField = UITextField().then {
        $0.setTextFieldUI("이름", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let contactTextField = HBTIContactTextFieldView(title: "휴대전화")
    
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
         saveInfoButton,
         nameLabel,
         nameTextField,
         contactTextField
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        saveInfoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        contactTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
