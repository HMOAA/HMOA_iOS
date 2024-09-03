//
//  HBTITotalPaymentView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/30/24.
//

import UIKit
import SnapKit
import Then

final class HBTITotalPaymentView: UIView {
    
    // MARK: - UI Components
    
    private let paymentTitleLabel = UILabel().then {
        $0.setLabelUI("결제금액", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let paymentPriceLabel = UILabel().then {
        $0.setLabelUI("15,000원", font: .pretendard_bold, size: 18, color: .red)
    }
    
    private let paymentSeparator1 = HBTIOrderDividingLineView(color: .customColor(.gray1))
    
    private let totalProductPaymentTitleLabel = UILabel().then {
        $0.setLabelUI("총 상품금액", font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    private let totalProductPaymentPriceLabel = UILabel().then {
        $0.setLabelUI("12,000원", font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    private let deliveryFeeTitleLabel = UILabel().then {
        $0.setLabelUI("배송비", font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    private let deliveryFeePriceLabel = UILabel().then {
        $0.setLabelUI("3,000원", font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    private let paymentSeparator2 = HBTIOrderDividingLineView(color: .customColor(.gray1))
    
    private let totalPaymentTitleLabel = UILabel().then {
        $0.setLabelUI("총 결제금액", font: .pretendard_semibold, size: 12, color: .black)
    }
    
    private let totalPaymentPriceLabel = UILabel().then {
        $0.setLabelUI("15,000원", font: .pretendard_semibold, size: 12, color: .black)
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
         paymentTitleLabel,
         paymentPriceLabel,
         paymentSeparator1,
         totalProductPaymentTitleLabel,
         totalProductPaymentPriceLabel,
         deliveryFeeTitleLabel,
         deliveryFeePriceLabel,
         paymentSeparator2,
         totalPaymentTitleLabel,
         totalPaymentPriceLabel
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        paymentTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        paymentPriceLabel.snp.makeConstraints {
            $0.top.equalTo(paymentTitleLabel.snp.top)
            $0.trailing.equalToSuperview()
        }
        
        paymentSeparator1.snp.makeConstraints {
            $0.top.equalTo(paymentTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalProductPaymentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(paymentSeparator1.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        totalProductPaymentPriceLabel.snp.makeConstraints {
            $0.top.equalTo(totalProductPaymentTitleLabel.snp.top)
            $0.trailing.equalToSuperview()
        }
        
        deliveryFeeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(totalProductPaymentTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        deliveryFeePriceLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeTitleLabel.snp.top)
            $0.trailing.equalToSuperview()
        }
        
        paymentSeparator2.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalPaymentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(paymentSeparator2.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        totalPaymentPriceLabel.snp.makeConstraints {
            $0.top.equalTo(totalPaymentTitleLabel.snp.top)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
