//
//  HBTIProductInfoView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class HBTIProductInfoView: UIView {
    
    // MARK: - Properties
    
    private let products: [HBTIOrderSheetProductData] = HBTIOrderSheetProductData.productData
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("상품 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private lazy var productTableView = UITableView().then {
        $0.register(HBTIProductInfoCell.self, forCellReuseIdentifier: HBTIProductInfoCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
         titleLabel,
         productTableView
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        productTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(204)
            $0.bottom.equalToSuperview()
        }
    }
}

extension HBTIProductInfoView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HBTIProductInfoCell.reuseIdentifier, for: indexPath) as? HBTIProductInfoCell else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configureCell(with: product)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 윗 공백 (20) + 아랫 공백 (20) + 셀 본래 높이 (62)
        return 102
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 맨 마지막 셀 구분선 제거
        if indexPath.row == products.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
}
