//
//  HBTINoteCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/5/24.
//

import UIKit

import SnapKit
import Then

final class HBTINoteCell: UICollectionViewCell {
    static let identifier = "HBTINoteCell"
    
    // MARK: - UI Components
    let tagLabel = UILabel().then {
        $0.setLabelUI("tag", font: .pretendard, size: 12, color: .black)
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
    
    // MARK: - Setup Methods
    
    private func setUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.customColor(.gray2).cgColor
        layer.cornerRadius = frame.height / 2
    }
    
    private func setAddView() {
        addSubview(tagLabel)
    }
    
    private func setConstraints() {
        tagLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureCell(_ noteName: String) {
        tagLabel.text = noteName
    }
}
