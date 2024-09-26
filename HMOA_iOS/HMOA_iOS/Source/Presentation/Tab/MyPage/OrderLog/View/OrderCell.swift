//
//  OrderCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/24/24.
//

import UIKit

import Then
import SnapKit

final class OrderCell: UICollectionViewCell {
    
    static let identifier = "OrderCell"
    
    // MARK: UI Components
    
    private let statusLabel = UILabel().then {
        $0.setLabelUI("상태", font: .pretendard_bold, size: 12, color: .black)
    }
    
    private let decoLine = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray1)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private let separatorLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let shippingInfoLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
        $0.setTextWithLineHeight(text: "택배사:모아택배\n운송장번호:123456789", lineHeight: 12)
        $0.numberOfLines = 2
    }
    
    private let shippingPriceTitleLabel = UILabel().then {
        $0.setLabelUI("배송비", font: .pretendard, size: 12, color: .gray3)
    }
    
    private let shippingPriceValueLabel = UILabel().then {
        $0.setLabelUI("0000원", font: .pretendard, size: 12, color: .gray3)
    }
    
    private let totalAmountTitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 18, color: .black)
        $0.setTextWithLineHeight(text: "결제금액", lineHeight: 20)
    }
    
    private let totalAmountValueLabel = UILabel().then {
        $0.setLabelUI("15,000원", font: .pretendard_bold, size: 20, color: .red)
    }
    
    private let returnRefundButton = UIButton().then {
        $0.setTitle("이동 버튼", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 12)
        $0.setTitleColor(.customColor(.gray3), for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.gray3).cgColor
        $0.layer.cornerRadius = 3
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
    
    // MARK: - Function
    
    private func setUI() {
        
    }
    
    private func setAddView() {
        [
            statusLabel,
            decoLine,
            categoryStackView,
            shippingInfoLabel,
            shippingPriceTitleLabel,
            shippingPriceValueLabel,
            separatorLineView,
            totalAmountTitleLabel,
            totalAmountValueLabel,
            returnRefundButton
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        statusLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        decoLine.snp.makeConstraints { make in
            make.centerY.equalTo(statusLabel.snp.centerY)
            make.leading.equalTo(statusLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        shippingInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(80)
        }
        
        shippingPriceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingInfoLabel.snp.bottom).offset(18)
            make.trailing.equalTo(shippingPriceValueLabel.snp.leading).offset(-7)
        }
        
        shippingPriceValueLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingPriceTitleLabel.snp.top)
            make.trailing.equalToSuperview()
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.top.equalTo(shippingPriceTitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        totalAmountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
        }
        
        totalAmountValueLabel.snp.makeConstraints { make in
            make.top.equalTo(totalAmountTitleLabel.snp.top)
            make.trailing.equalToSuperview()
        }
        
        returnRefundButton.snp.makeConstraints { make in
            make.top.equalTo(totalAmountTitleLabel.snp.bottom).offset(32)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
    }
    
    func configureCell() {
        let category1 = OrderCategoryView()
        let category2 = OrderCategoryView()
        
        [
            category1,
            category2
        ]   .forEach {
            $0.configureView()
            $0.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(90)
            }
            categoryStackView.addArrangedSubview($0)
        }
    }
}
