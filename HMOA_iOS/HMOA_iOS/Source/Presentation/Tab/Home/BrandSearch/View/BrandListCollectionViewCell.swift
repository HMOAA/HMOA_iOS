//
//  BrandListCollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

import UIKit
import Then

class BrandListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "BrandListCollectionViewCell"
    
    // MARK: - UI Component
    let brandNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .black)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrandListCollectionViewCell {
    
    // MARK: - Configure
    private func setUI() {
        isSelected = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.customColor(.gray2).cgColor
        layer.cornerRadius = frame.height / 2
    }
    
    private func setAddView() {
        [
            brandNameLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        brandNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func updateCell(_ item: Brand)  {
        brandNameLabel.text = item.brandName
    }
}
