//
//  MyPageSwitchCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/2/23.
//

import UIKit

import RxSwift
import SnapKit

class MyPageSwitchCell: UITableViewCell {
    
    // MARK: - identifier
    
    static let identifier = "MyPageSwitchCell"
    
    // MARK: - Properies
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 16)
        $0.textAlignment = .left
    }
    
    var disposeBag = DisposeBag()
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

// MARK: - Lifecycle

extension MyPageSwitchCell {
    
    private func configureUI() {
        [   titleLabel
        ]   .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    func updateCell(_ text: String) {
        titleLabel.text = text
    }
}
