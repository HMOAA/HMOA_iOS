//
//  OrderCancelLogCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/25/24.
//

import UIKit

import SnapKit
import Then

final class OrderCancelLogCell: UITableViewCell {

    // MARK: - identifier
    
    static let identifier = "OrderCancelLogCell"
    
    // MARK: - Properties
    
    private let statusLabel = UILabel().then {
        $0.setLabelUI("상태", font: .pretendard_bold, size: 12, color: .black)
    }

    private let decoLine = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray1)
    }
    
    private let dateLabel = UILabel().then {
        $0.setLabelUI("0000/00/00", font: .pretendard_bold, size: 12, color: .gray3)
    }

    private let categoryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setAddView() {
        [
            statusLabel,
            decoLine,
            dateLabel,
            categoryStackView
        ]   .forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        statusLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        decoLine.snp.makeConstraints { make in
            make.centerY.equalTo(statusLabel.snp.centerY)
            make.leading.equalTo(statusLabel.snp.trailing).offset(16)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-12)
            make.height.equalTo(1)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(decoLine.snp.centerY)
            make.leading.equalTo(decoLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configureCell(order: Order) {
        let status = OrderStatus(rawValue: order.status)
        let categoryList = order.products.categoryListInfo.categoryList
        
        setStatusLabel(for: status)
        setCategoryStackView(categoryList)
        dateLabel.setLabelUI(order.createdAt, font: .pretendard_bold, size: 12, color: .gray3)
    }
    
}

extension OrderCancelLogCell {
    private func setCategoryStackView(_ categoryList: [HBTICategory]) {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        categoryList.forEach {
            let categoryView = OrderCancelCategoryView()
            categoryView.configureView(category: $0)
            categoryView.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(61)
            }
            categoryStackView.addArrangedSubview(categoryView)
        }
    }
    
    private func setStatusLabel(for status: OrderStatus?) {
        guard let status = status else { return }
        statusLabel.text = status.kr
        statusLabel.textColor = status.textColor
    }
}
