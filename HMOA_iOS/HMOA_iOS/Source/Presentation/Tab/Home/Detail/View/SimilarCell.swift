//
//  SimilarCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

class SimilarCell: UICollectionViewCell, View {
    
    // MARK: - identifier
    typealias Reactor = HomeCellReactor
    var disposeBag = DisposeBag()
    
    static let identifier = "SimilarCell"
    
    // MARK: - Properties
    
    lazy var perfumeImageView = UIImageView()
    
    lazy var perfumetitleLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 12)
        $0.text = "조 말론 런던"
    }
    
    lazy var perfumeContentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = UIColor.customColor(.labelGrayColor)
        $0.font = UIFont.customFont(.pretendard, 10)
        $0.text = "우드 세이지 앤 씨 솔트 코롱 100ml"
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions

extension SimilarCell {
    
    func bind(reactor: HomeCellReactor) {
//        perfumeImageView.image = reactor.currentState.image
        perfumetitleLabel.text = reactor.currentState.title
        perfumeContentLabel.text = reactor.currentState.content
    }
    
    func configureUI() {
        
        [   perfumeImageView,
            perfumetitleLabel,
            perfumeContentLabel ] .forEach { addSubview($0) }
                
        perfumeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        perfumetitleLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        perfumeContentLabel.snp.makeConstraints {
            $0.top.equalTo(perfumetitleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(perfumetitleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateUI(_ item: SimilarPerfume) {
        perfumetitleLabel.text = item.brandName
        perfumeContentLabel.text = item.perfumeName
        perfumeImageView.kf.setImage(with: URL(string: item.perfumeImgUrl))
    }
}
