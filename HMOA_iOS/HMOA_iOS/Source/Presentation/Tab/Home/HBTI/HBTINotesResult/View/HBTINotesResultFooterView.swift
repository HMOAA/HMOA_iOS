//
//  HBTINotesResultFooterView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/24/24.
//

import UIKit
import SnapKit
import Then

class HBTINotesResultFooterView: UITableViewHeaderFooterView, ReuseIdentifying {
    
    // MARK: - UI Components
   
    private let totalPriceLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 15)
        $0.text = "총 금액 : 15,000 원"
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
       
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        contentView.addSubview(totalPriceLabel)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

