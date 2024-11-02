//
//  HBTIAddressTextFieldView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

protocol HBTIAddressTextFieldViewDelegate: AnyObject {
    func didTapReturnOnDetailAddressTextField()
    func didReceiveAddress(postCode: String, address: String)
}

final class HBTIAddressTextFieldView: UIView {
    
    //MARK: Properties
    
    private let title: String
    weak var delegate: HBTIAddressTextFieldViewDelegate?
    
    let zipCodeSubject = PublishSubject<String>()
    let addressSubject = PublishSubject<String>()
    
    // MARK: UI Components
    
    private lazy var titleLabel = UILabel().then {
        $0.setLabelUI(title, font: .pretendard_medium, size: 12, color: .black)
    }
    
    let postCodeTextField = UITextField().then {
        $0.setTextFieldUI("우편번호", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.isEnabled = false
    }
    
    lazy var findAddressButton = UIButton().then {
        $0.setTitle("주소 찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .customColor(.gray1)
        $0.titleLabel?.font = .customFont(.pretendard_medium, 10)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapFindAddressButton), for: .touchUpInside)
    }
    
    let addressTextField = UITextField().then {
        $0.setTextFieldUI("주소", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.isEnabled = false
    }
    
    lazy var detailAddressTextField = UITextField().then {
        $0.setTextFieldUI("상세주소", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
        $0.returnKeyType = .next
    }
    
    // MARK: - Initialization

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setAddView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set AddView

    private func setAddView() {
        [
         titleLabel,
         postCodeTextField,
         findAddressButton,
         addressTextField,
         detailAddressTextField
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        postCodeTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        findAddressButton.snp.makeConstraints {
            $0.centerY.equalTo(postCodeTextField)
            $0.trailing.equalTo(postCodeTextField.snp.trailing).inset(9)
            $0.width.equalTo(46)
            $0.height.equalTo(20)
        }
        
        addressTextField.snp.makeConstraints {
            $0.top.equalTo(postCodeTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        detailAddressTextField.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Other Functions
    
    @objc private func didTapFindAddressButton() {
        let hbtiZipCodeVC = HBTIZipCodeViewController()
        hbtiZipCodeVC.delegate = self
        
        if let topVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController {
            
            topVC.present(hbtiZipCodeVC, animated: true, completion: nil)
        }
    }
}

extension HBTIAddressTextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == detailAddressTextField {
            delegate?.didTapReturnOnDetailAddressTextField()
            return true
        }
        return false
    }
}

extension HBTIAddressTextFieldView: HBTIZipCodeViewControllerDelegate {
    func didReceiveAddress(postCode: String, address: String) {
        postCodeTextField.text = postCode
        addressTextField.text = address
        
        zipCodeSubject.onNext(postCode)
        addressSubject.onNext(address)
    }
}
