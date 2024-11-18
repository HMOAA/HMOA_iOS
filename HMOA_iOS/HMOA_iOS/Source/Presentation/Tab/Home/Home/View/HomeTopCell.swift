//
//  HomeTopCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift

class HomeTopCell: UICollectionViewCell {
    
    // MARK: - identifier
    static let identifier = "HomeTopCell"
    
    // MARK: - Properies
    
    var disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("무료 향BTI 검사 후\n당신만의 향을 찾아보세요", font: .pretendard_medium, size: 20, color: .white)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let bannerView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
    }
    
    private lazy var newsImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var hbtiButton = UIButton().then {
        $0.setTitle("# 향bti 검사하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 14)
        $0.backgroundColor = .customColor(.gray4)
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

// MARK: Functions

extension HomeTopCell {
    
    func configureUI() {
        
        [
            bannerView
        ].forEach { addSubview($0) }
        
        [
            titleLabel,
            newsImageView,
            hbtiButton
        ].forEach { bannerView.addSubview($0)}
        
        
        // 배너 문구 라벨
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
        }
        
        // 배너 이미지뷰
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalTo(hbtiButton.snp.top).offset(-10)
        }
        
        // 배너 뷰
        bannerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        // 향BTI 버튼
        hbtiButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(bannerView.snp.horizontalEdges).inset(16)
            make.bottom.equalTo(bannerView.snp.bottom).inset(10)
            make.height.equalTo(48)
        }
    }
    
    func setImage(_ item: HomeFirstData) {
        let url = URL(string: item.mainImage)
        newsImageView.kf.setImage(with: url)
    }
}
