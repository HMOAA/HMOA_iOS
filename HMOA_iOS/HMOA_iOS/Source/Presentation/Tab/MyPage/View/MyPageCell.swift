//
//  MyPageCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit

class MyPageCell: UITableViewCell {
    
    // MARK: - identifier
    
    static let identifier = "MyPageCell"
    
    // MARK: - Properies
    
    let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 16)
        $0.textAlignment = .left
    }
    
    lazy var rightArrowImageView = UIImageView().then {
        $0.image = UIImage(named: "rightArrow")
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension MyPageCell {
    
    func configureUI() {
        [   titleLabel,
            rightArrowImageView
        ]   .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func updateCell(_ text: String) {
        titleLabel.text = text
    }
}
