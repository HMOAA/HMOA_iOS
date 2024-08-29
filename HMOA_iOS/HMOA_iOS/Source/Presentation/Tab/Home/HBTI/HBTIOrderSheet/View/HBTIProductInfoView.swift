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
        
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        
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
        
        return cell
    }
}
