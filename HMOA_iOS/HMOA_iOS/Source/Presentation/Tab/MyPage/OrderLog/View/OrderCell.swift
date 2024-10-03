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
    
    private let shippingInfoView = UIView()
    
    private let shippingCompanyLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
        $0.setTextWithLineHeight(text: "택배사:모아택배", lineHeight: 12)
    }
    
    private let shippingTrackingNumberLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
        $0.setTextWithLineHeight(text: "운송장번호:123456789", lineHeight: 12)
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
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    private let refundRequestButton = UIButton().grayBorderButton(title: "환불 신청")
    
    private let returnRequestButton = UIButton().grayBorderButton(title: "반품 신청")
    
    private let reviewButton = UIButton().grayBorderButton(title: "후기 작성")
    
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
            shippingInfoView,
            shippingPriceTitleLabel,
            shippingPriceValueLabel,
            separatorLineView,
            totalAmountTitleLabel,
            totalAmountValueLabel,
            buttonStackView
        ]   .forEach { addSubview($0) }
        
        [
            shippingCompanyLabel,
            shippingTrackingNumberLabel
        ]   .forEach { shippingInfoView.addSubview($0) }
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
        
        shippingInfoView.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom)
            make.leading.equalToSuperview().inset(80)
            make.height.equalTo(44)
        }
        
        shippingCompanyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        shippingTrackingNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingCompanyLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        shippingPriceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingInfoView.snp.bottom).offset(18)
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
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(totalAmountTitleLabel.snp.bottom).offset(32)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
    }
    
    func configureCell(order: Order) {
        let status = OrderStatus(rawValue: order.status)
        let categoryList = order.products.categoryListInfo.categoryList
        
        setStatusLabel(for: status)
        setCategoryStackView(categoryList)
        setShippingInfoView(company: order.courierCompany, trackingNumber: order.trackingNumber)
        shippingPriceValueLabel.text = order.products.shippingFee.numberFormatterToHangulWon()
        totalAmountValueLabel.text = order.products.totalAmount.numberFormatterToHangulWon()
        setButtonComposition(for: status)
    }
}

extension OrderCell {
    private func setCategoryStackView(_ categoryList: [HBTICategory]) {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        categoryList.forEach {
            let categoryView = OrderCategoryView()
            categoryView.configureView(category: $0)
            categoryView.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(90)
            }
            categoryStackView.addArrangedSubview(categoryView)
        }
    }
    
    private func setStatusLabel(for status: OrderStatus?) {
        guard let status = status else { return }
        statusLabel.text = status.kr
        statusLabel.textColor = status.textColor
    }
    
    private func setShippingInfoView(company: String?, trackingNumber: String?) {
        if let company = company,
           let trackingNumber = trackingNumber {
            shippingCompanyLabel.text = "택배사:\(company)"
            shippingTrackingNumberLabel.text = "운송장번호:\(trackingNumber)"
            shippingInfoView.snp.updateConstraints { make in
                make.height.equalTo(44)
            }
        } else {
            shippingInfoView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
    
    private func setButtonComposition(for status: OrderStatus?) {
        guard let status = status else { return }
        
        switch status {
        case .PAY_COMPLETE:
            buttonStackView.addArrangedSubview(refundRequestButton)
        case .SHIPPING_PROGRESS:
            buttonStackView.addArrangedSubview(returnRequestButton)
        case .SHIPPING_COMPLETE:
            [
                returnRequestButton,
                reviewButton
            ]   .forEach { buttonStackView.addArrangedSubview($0) }
        default:
            break
        }
    }
}
