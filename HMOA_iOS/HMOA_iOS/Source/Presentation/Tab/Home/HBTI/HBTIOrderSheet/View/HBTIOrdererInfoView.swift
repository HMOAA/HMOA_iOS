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
    
    private let contactLabel = UILabel().then {
        $0.setLabelUI("휴대전화", font: .pretendard_medium, size: 12, color: .black)
    }
    
    private let contactTextFieldFirst = UITextField().then {
        $0.setTextFieldUI("000", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let firstLine = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let contactTextFieldSecond = UITextField().then {
        $0.setTextFieldUI("0000", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let secondeLine = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let contactTextFieldThird = UITextField().then {
        $0.setTextFieldUI("0000", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
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
         contactLabel,
         contactTextFieldFirst,
         firstLine,
         contactTextFieldSecond,
         secondeLine,
         contactTextFieldThird
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
        
        contactLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        contactTextFieldFirst.snp.makeConstraints {
            $0.top.equalTo(contactLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy((1.0 / 3.0) - (40 / UIScreen.main.bounds.width / 3.0)) // 휴대폰번호 텍스트필드 간격 20 * 2를 뺀 superView width를 3으로 나누기
            $0.height.equalTo(44)
        }
        
        firstLine.snp.makeConstraints {
            $0.leading.equalTo(contactTextFieldFirst.snp.trailing).offset(5)
            $0.centerY.equalTo(contactTextFieldFirst)
            $0.width.equalTo(10)
            $0.height.equalTo(1)
        }
        
        contactTextFieldSecond.snp.makeConstraints {
            $0.top.equalTo(contactTextFieldFirst.snp.top)
            $0.leading.equalTo(contactTextFieldFirst.snp.trailing).offset(20)
            $0.width.equalToSuperview().multipliedBy((1.0 / 3.0) - (40 / UIScreen.main.bounds.width / 3.0)) // 휴대폰번호 텍스트필드 간격 20 * 2를 뺀 superView width를 3으로 나누기
            $0.height.equalTo(44)
        }
        
        secondeLine.snp.makeConstraints {
            $0.leading.equalTo(contactTextFieldSecond.snp.trailing).offset(5)
            $0.centerY.equalTo(contactTextFieldSecond)
            $0.width.equalTo(10)
            $0.height.equalTo(1)
        }
        
        contactTextFieldThird.snp.makeConstraints {
            $0.top.equalTo(contactTextFieldFirst.snp.top)
            $0.leading.equalTo(contactTextFieldSecond.snp.trailing).offset(20)
            $0.width.equalToSuperview().multipliedBy((1.0 / 3.0) - (40 / UIScreen.main.bounds.width / 3.0)) // 휴대폰번호 텍스트필드 간격 20 * 2를 뺀 superView width를 3으로 나누기
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }
}
