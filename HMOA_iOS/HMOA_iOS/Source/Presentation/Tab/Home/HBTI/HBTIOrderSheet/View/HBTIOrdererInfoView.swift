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
    
    private var isNonMemberInfoVisible = true
    
    // MARK: - UI Components
    
    private let orderMemberInfoStackView = UIStackView()
    
    private let nonMemberInfoView = UIView()
    
    private let nonMemberTitleLabel = UILabel().then {
        $0.setLabelUI("주문자 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    let saveInfoButton = UIButton().makeUnderLineButton(text: "작성한 정보 저장하기", textColor: .black)
    
    private let nameLabel = UILabel().then {
        $0.setLabelUI("이름", font: .pretendard_medium, size: 12, color: .black)
    }
    
    lazy var nameTextField = UITextField().then {
        $0.setTextFieldUI("이름", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
        $0.returnKeyType = .next
    }
    
    let contactTextField = HBTIContactTextFieldView(title: "휴대전화")
    
    private let memberInfoView = UIView()
    
    private let memberTitleLabel = UILabel().then {
        $0.setLabelUI("주문자 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let addressNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    private let defaultAddressButton = UIButton().then {
        $0.setTitle("기본 배송지", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .customColor(.gray1)
        $0.titleLabel?.font = .customFont(.pretendard_medium, 10)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    private let phoneNumberLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    private let addressLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 12, color: .black)
    }
    
    let modifyInfoButton = UIButton().makeUnderLineButton(text: "변경하기", textColor: .black)
    
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
        addSubview(orderMemberInfoStackView)
        
        [
         nonMemberInfoView,
         memberInfoView
        ].forEach(orderMemberInfoStackView.addArrangedSubview)
        
        [
         nonMemberTitleLabel,
         saveInfoButton,
         nameLabel,
         nameTextField,
         contactTextField
        ].forEach(nonMemberInfoView.addSubview)
        
        [
         memberTitleLabel,
         addressNameLabel,
         defaultAddressButton,
         modifyInfoButton,
         phoneNumberLabel,
         addressLabel
        ].forEach(memberInfoView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        orderMemberInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nonMemberTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        saveInfoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(nonMemberTitleLabel)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(nonMemberTitleLabel.snp.bottom).offset(20)
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
        
        memberTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addressNameLabel.snp.makeConstraints {
            $0.top.equalTo(memberTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        defaultAddressButton.snp.makeConstraints {
            $0.centerY.equalTo(addressNameLabel)
            $0.leading.equalTo(addressNameLabel.snp.trailing).offset(8)
            $0.width.equalTo(55)
            $0.height.equalTo(20)
        }
        
        modifyInfoButton.snp.makeConstraints {
            $0.centerY.equalTo(addressNameLabel)
            $0.trailing.equalToSuperview()
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(defaultAddressButton.snp.bottom).offset(6)
            $0.leading.equalTo(memberTitleLabel.snp.leading).offset(1)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(18)
            $0.leading.equalTo(memberTitleLabel.snp.leading)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: Other Functions
    
    func setMemberInfoViewVisible(isSavedAddress: Bool, addressName: String, memberName: String, phoneNumber: String, address: String) {
        addressNameLabel.text = "\(addressName)(\(memberName))"
        phoneNumberLabel.text = phoneNumber
        addressLabel.text = address
        
        if isSavedAddress {
            if nonMemberInfoView.superview != nil {
                orderMemberInfoStackView.removeArrangedSubview(nonMemberInfoView)
                nonMemberInfoView.removeFromSuperview()
            }
            if memberInfoView.superview == nil {
                orderMemberInfoStackView.addArrangedSubview(memberInfoView)
            }
        } else {
            if memberInfoView.superview != nil {
                orderMemberInfoStackView.removeArrangedSubview(memberInfoView)
                memberInfoView.removeFromSuperview()
            }
            if nonMemberInfoView.superview == nil {
                orderMemberInfoStackView.addArrangedSubview(nonMemberInfoView)
            }
        }
    }
}

extension HBTIOrdererInfoView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let restrictedCharacters = CharacterSet
                                        .decimalDigits
                                        .union(.punctuationCharacters)
                                        .union(.symbols)
                                        .union(.whitespaces)
            
        // restrictedCharacters에 포함되지 않는 문자만 허용 (한글, 알파벳만 허용)
        if string.rangeOfCharacter(from: restrictedCharacters) != nil {
            return false
        }
        
        return true
    }
      
    // 키보드에서 next버튼 누를 때 다음 텍스트 필드로 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return moveToNextTextField(currentTextField: textField, nextTextField: contactTextField.contactTextFieldFirst)
    }
}

