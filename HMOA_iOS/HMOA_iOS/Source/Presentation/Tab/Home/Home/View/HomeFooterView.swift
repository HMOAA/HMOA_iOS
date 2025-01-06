//
//  HomeFooterView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 1/6/25.
//

import UIKit

class HomeFooterView: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - UI Components
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    let businessNumberLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .white)
    }
    
    let representativeLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .white)
    }
    
    let privacyOfficerLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .white)
    }
    
    let salesLicenseLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .white)
    }
    
    let addressLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .white)
    }
    
    let customerCenterLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .white)
    }
    
    // MARK: - Init
    
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
        backgroundColor = .black
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            businessNumberLabel,
            representativeLabel,
            privacyOfficerLabel,
            salesLicenseLabel,
            addressLabel,
            customerCenterLabel
        ].forEach{ stackView.addArrangedSubview($0) }
        
        [stackView].forEach{ addSubview($0) }
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(36)
        }
    }
    
    // MARK: - Configuration
    
    func configureFooter() {
        let businessInfo = BusinessInfo.businessInfo
        businessNumberLabel.text = "사업자 번호: \(businessInfo.businessNumber)"
        representativeLabel.text = "향모아 / 대표자 : \(businessInfo.representativeName)"
        privacyOfficerLabel.text = "개인정보보호책임자 : \(businessInfo.privacyOfficer)"
        salesLicenseLabel.text = "통신판매업 : \(businessInfo.salesLicense)"
        addressLabel.text = "주소 : \(businessInfo.address)"
        customerCenterLabel.text = "고객센터 : \(businessInfo.customerCenter)"
    }
}
