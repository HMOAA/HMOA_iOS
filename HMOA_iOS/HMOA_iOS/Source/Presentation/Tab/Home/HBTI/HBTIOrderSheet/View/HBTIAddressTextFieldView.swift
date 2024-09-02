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
    
    private let postCodeTextField = UITextField().then {
        $0.setTextFieldUI("우편번호", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let findAddressButton = UIButton().then {
        $0.setTitle("주소 찾기", for: .normal)
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let addressTextField = UITextField().then {
        $0.setTextFieldUI("주소", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let detailAddressTextField = UITextField().then {
        $0.setTextFieldUI("상세주소", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
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
         postCodeTextField,
         findAddressButton,
         addressTextField,
         detailAddressTextField
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        
    }
}
