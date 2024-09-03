//
//  HBTIAddAddressViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then

final class HBTIAddAddressViewController: UIViewController {

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
         saveAddressInfoButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        saveAddressInfoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}
