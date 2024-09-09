//
//  HBTIAddAddressViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then

final class HBTIAddFixAddressViewController: UIViewController {

    // MARK: - UI Components
    private let receiverInfoLabel = UILabel().then {
        $0.setLabelUI("배송자 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let receiverNameLabel = UILabel().then {
        $0.setLabelUI("이름", font: .pretendard_medium, size: 12, color: .black)
    }
    
    private let receiverNameTextField = UITextField().then {
        $0.setTextFieldUI("수령인", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let receiverAddressNameLabel = UILabel().then {
        $0.setLabelUI("배송지명(선택)", font: .pretendard_medium, size: 12, color: .black)
    }
    
    private let receiverAddressNameTextField = UITextField().then {
        $0.setTextFieldUI("배송지명", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let phoneNumberTextFieldView = HBTIContactTextFieldView(title: "휴대전화")
    
    private let contactTextFieldView = HBTIContactTextFieldView(title: "전화번호")
    
    private let addressTextFieldView = HBTIAddressTextFieldView(title: "주소")

    private let deliveryRequestLabel = UILabel().then {
        $0.setLabelUI("배송 요청사항(선택)", font: .pretendard_medium, size: 12, color: .black)
    }
    
    private let deliveryRequestTextField = UITextField().then {
        $0.setTextFieldUI("배송 시 요청사항을 선택해주세요", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let saveAddressInfoButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        bind()
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: Action
        
        // MARK: State
        
    }
    
    // MARK: Set UI
   
    private func setUI() {
        setBackItemNaviBar("주소 추가")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         receiverInfoLabel,
         receiverNameLabel,
         receiverNameTextField,
         receiverAddressNameLabel,
         receiverAddressNameTextField,
         phoneNumberTextFieldView,
         contactTextFieldView,
         addressTextFieldView,
         deliveryRequestLabel,
         deliveryRequestTextField,
         saveAddressInfoButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        receiverInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.equalToSuperview().offset(16)
        }
        
        receiverNameLabel.snp.makeConstraints {
            $0.top.equalTo(receiverInfoLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        receiverNameTextField.snp.makeConstraints {
            $0.top.equalTo(receiverNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        receiverAddressNameLabel.snp.makeConstraints {
            $0.top.equalTo(receiverNameTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        receiverAddressNameTextField.snp.makeConstraints {
            $0.top.equalTo(receiverAddressNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        phoneNumberTextFieldView.snp.makeConstraints {
            $0.top.equalTo(receiverAddressNameTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contactTextFieldView.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextFieldView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        addressTextFieldView.snp.makeConstraints {
            $0.top.equalTo(contactTextFieldView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        deliveryRequestLabel.snp.makeConstraints {
            $0.top.equalTo(addressTextFieldView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        deliveryRequestTextField.snp.makeConstraints {
            $0.top.equalTo(deliveryRequestLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        saveAddressInfoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}
