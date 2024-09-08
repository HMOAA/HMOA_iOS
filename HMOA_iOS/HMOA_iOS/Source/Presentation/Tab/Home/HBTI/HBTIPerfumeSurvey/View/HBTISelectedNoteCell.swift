//
//  HBTISelectedNoteCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/5/24.
//

import UIKit

import SnapKit
import Then

final class HBTISelectedNoteCell: UICollectionViewCell {
    static let identifier = "HBTIselectedNoteCell"
    
    // MARK: - UI Components
    let tagLabel = UILabel().then {
        $0.setLabelUI("tag", font: .pretendard, size: 12, color: .white)
    }
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "noteXButton"), for: .normal)
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
        layer.cornerRadius = frame.height / 2
        backgroundColor = UIColor.customColor(.gray3)
    }
    
    private func setAddView() {
        [
            tagLabel,
            xButton
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        tagLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(16)
        }
        
        xButton.snp.makeConstraints { make in
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.leading.equalTo(tagLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(12)
        }
    }
    
    func configureCell(_ noteName: String) {
        tagLabel.text = noteName
    }
}
