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
    let noteNameLabel = UILabel().then {
        $0.setLabelUI("tag", font: .pretendard, size: 12, color: .black)
    }
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            layer.backgroundColor = isSelected ? UIColor.black.cgColor : UIColor.white.cgColor
            layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.customColor(.gray2).cgColor
            noteNameLabel.textColor = isSelected ? .white : .black
        }
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
        isSelected = false
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
    }
    
    private func setAddView() {
        [
            noteNameLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        noteNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureCell(_ noteName: String) {
        noteNameLabel.text = noteName
    }
}
