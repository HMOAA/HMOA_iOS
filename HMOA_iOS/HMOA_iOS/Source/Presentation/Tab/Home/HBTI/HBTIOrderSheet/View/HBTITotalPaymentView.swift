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
    
    private let paymentLabel = UILabel().then {
        $0.setLabelUI("15,000원", font: .pretendard_bold, size: 18, color: .red)
    }
    
    private
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
        
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        
    }
}
