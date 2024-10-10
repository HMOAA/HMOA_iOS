//
//  HBTIContactTextFieldView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then

final class HBTIContactTextFieldView: UIView {
    
    // MARK: - Properties
    private let title: String
    
    // MARK: UI Components
    
    private lazy var titleLabel = UILabel().then {
        $0.setLabelUI(title, font: .pretendard_medium, size: 12, color: .black)
    }
    
    lazy var contactTextFieldFirst = UITextField().then {
        $0.setTextFieldUI("000", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
    }
    
    private let contactFirstLine = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    lazy var contactTextFieldSecond = UITextField().then {
        $0.setTextFieldUI("0000", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
    }
    
    private let contactSecondLine = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    lazy var contactTextFieldThird = UITextField().then {
        $0.setTextFieldUI("0000", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
    }
    
    // MARK: - Initialization

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
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
         contactTextFieldFirst,
         contactFirstLine,
         contactTextFieldSecond,
         contactSecondLine,
         contactTextFieldThird
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        contactTextFieldFirst.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy((1.0 / 3.0) - (40 / UIScreen.main.bounds.width / 3.0)) // 휴대폰번호 텍스트필드 간격 20 * 2를 뺀 superView width를 3으로 나누기
            $0.height.equalTo(44)
        }
        
        contactFirstLine.snp.makeConstraints {
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
        
        contactSecondLine.snp.makeConstraints {
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

extension HBTIContactTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백스페이스 입력 시, 문자 삭제
        if string.isEmpty {
            return true
        }
        
        // 숫자만 입력 허용 (한글, 영문, 특수문자 차단)
        let allowedCharacters = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        
        guard let contactText = textField.text else { return true }
        
        switch textField {
        case contactTextFieldFirst:
            return contactText.count < 3
        case contactTextFieldSecond, contactTextFieldThird:
            return contactText.count < 4
        default:
            return true
        }
    }
}
