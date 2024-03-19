//
//  MagazineAllCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit
import SnapKit
import Then

class MagazineAllCell: UICollectionViewCell {
    
    static let identifier = "MagazineAllCell"
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let coverImageView = UIImageView()
    
    private let sloganLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
    }
    
    private let perfumeNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private let longDescriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        [sloganLabel, perfumeNameLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [coverImageView, titleStackView, longDescriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(coverImageView.snp.width)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ magazine: Magazine) {
        coverImageView.backgroundColor = .random
        sloganLabel.text = "시들지 않는 아름다움,"
        perfumeNameLabel.text = "샤넬 오드 롱 코롱"
        longDescriptionLabel.text = "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다."
    }
}
