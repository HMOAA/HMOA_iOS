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
    
    // MARK: Properties
    
    private let paymentMethods: [PaymentMethodType] = HBTIPaymentMethodModel.paymentMethods
    
    // MARK: - UI Components
    
    private let paymentMethodTitleLabel = UILabel().then {
        $0.setLabelUI("결제수단", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private lazy var paymentMethodTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(HBTIPaymentMethodCell.self, forCellReuseIdentifier: HBTIPaymentMethodCell.reuseIdentifier)
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

extension HBTIPaymentMethodView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HBTIPaymentMethodCell.reuseIdentifier, for: indexPath) as? HBTIPaymentMethodCell else {
            return UITableViewCell()
        }
        
        let method = paymentMethods[indexPath.row]
        cell.configureCell(with: method)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 아랫 공백 (16) + 셀 본래 높이 (24)
        return 40
    }
}
