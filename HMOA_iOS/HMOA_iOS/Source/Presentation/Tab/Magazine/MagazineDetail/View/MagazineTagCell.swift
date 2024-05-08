//
//  MagazineTagCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/24/24.
//

import UIKit
import SnapKit
import Then

class MagazineTagCell: UICollectionViewCell {
    static let identifier = "MagazineTagCell"
    
    // MARK: - UI Components
    private let tagLabel = UILabel().then {
        $0.setLabelUI("tag", font: .pretendard, size: 12, color: .gray3)
        
//        $0.layer.borderColor = UIColor.customColor(.gray3)
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
        layer.borderColor = UIColor.customColor(.gray3).cgColor
        layer.cornerRadius = frame.height / 2
    }
    
    private func setAddView() {
        addSubview(tagLabel)
    }
    
    private func setConstraints() {
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(14)
        }
    }
    
    func configureCell(_ magazine: MagazineTag) {
        tagLabel.text = magazine.tag
    }
}
