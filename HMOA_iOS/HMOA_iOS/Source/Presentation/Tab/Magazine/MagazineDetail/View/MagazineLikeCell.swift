//
//  MagazineLikeCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/19/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

class MagazineLikeCell: UICollectionViewCell {
    
    static let identifier = "MagazineLikeCell"
    
    // MARK: - UI Components
    
    // 좋아요 스택 뷰
    private let likeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 55
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    // 좋아요 여부 라벨
    private let likeAskingLabel = UILabel().then {
        $0.setLabelUI("매거진이 유용한 정보였다면", font: .pretendard_medium, size: 16, color: .black)
    }
    
    // (좋아요 버튼 + 좋아요 수 라벨) 스택 뷰
    private let likeButtomStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    // 좋아요 버튼
    let likeButton = UIButton().then {
        let thumbsUp = UIImage(named: "thumbsUp")! as UIImage
        let thumbsUpBlack = thumbsUp.imageWithColor(color: .black)
        
        $0.setImage(thumbsUp, for: .normal)
        $0.setImage(thumbsUpBlack, for: .selected)
    }
    
    // 좋아요 수 라벨
    let likeCountLabel = UILabel().then {
        $0.setLabelUI("12,304", font: .pretendard_medium, size: 14, color: .gray2)
    }
    
    var disposeBag = DisposeBag()
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setAddView() {
        [likeStackView].forEach { addSubview($0) }
        
        // 스택 뷰
        [likeAskingLabel, likeButtomStackView].forEach { likeStackView.addArrangedSubview($0) }
        [likeButton, likeCountLabel].forEach { likeButtomStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        likeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ magazine: MagazineLike) {
        likeCountLabel.text = String(magazine.likeCount)
        likeCountLabel.textColor = magazine.isLiked ? .black : UIColor.customColor(.gray2)
        likeButton.isSelected = magazine.isLiked
    }
}
