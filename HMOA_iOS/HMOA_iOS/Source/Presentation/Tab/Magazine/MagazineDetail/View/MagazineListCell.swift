//
//  MagazineLatestCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/7/24.
//

import UIKit
import SnapKit
import Then

class MagazineListCell: UICollectionViewCell {
    
    static let identifier = "MagazineListCell"
    
    // MARK: - UI Components
    
    // 표지 이미지 뷰
    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // 제목 라벨
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .white)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setAddView() {
        [coverImageView, titleLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(132)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(184.0 / 132.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        titleLabel.text = magazine.title
        coverImageView.kf.setImage(with: URL(string: magazine.previewImageURL))
    }
}
