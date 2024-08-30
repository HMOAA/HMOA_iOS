//
//  HBTIPaymentMethodView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/30/24.
//

import UIKit
import SnapKit
import Then

final class HBTIPaymentMethodView: UIView {
    
    // MARK: - UI Components
    
    private let paymentMethodTitleLabel = UILabel().then {
        $0.setLabelUI("결제수단", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let paymentMethodTableView = UITableView().then {
        $0.isScrollEnabled = false
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
         paymentMethodTitleLabel,
         paymentMethodTableView
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        paymentMethodTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        paymentMethodTableView.snp.makeConstraints {
            $0.top.equalTo(paymentMethodTitleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(176)
            $0.bottom.equalToSuperview()
        }
    }
}
