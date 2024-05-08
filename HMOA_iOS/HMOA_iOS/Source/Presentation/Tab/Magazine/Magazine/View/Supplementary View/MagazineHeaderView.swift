//
//  MagazineHeaderView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import Then
import SnapKit

class MagazineHeaderView: UICollectionReusableView {
    
    static let identifier = "MagazineHeaderView"
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
        $0.numberOfLines = 0
    }
    
    let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddViews() {
        [titleLabel, descriptionLabel].forEach{ stackView.addArrangedSubview($0) }
        
        [stackView].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func configureHeader(_ title: String, _ description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
