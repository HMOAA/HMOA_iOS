//
//  HBTIPaymentMethodCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/30/24.
//

import UIKit
import SnapKit
import Then

final class HBTIPaymentMethodCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let checkImageView = UIImageView()
    
    private let paymentMethodTitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 12, color: .black)
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         checkImageView,
         paymentMethodTitleLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        paymentMethodTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkImageView.snp.trailing).offset(6)
        }
    }
    
    func configureCell(with method: PaymentMethodType) {
        switch method {
        case .toss:
            checkImageView.image = UIImage(named: "checkBoxSelected")
        default:
            checkImageView.image = UIImage(named: "checkBoxNotSelected")
        }
        
        paymentMethodTitleLabel.text = method.rawValue
    }
}

