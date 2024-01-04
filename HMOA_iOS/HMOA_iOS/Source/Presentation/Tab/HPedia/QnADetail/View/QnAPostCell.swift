//
//  QnAPostCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit
import RxSwift

class QnAPostCell: UICollectionViewCell {
    
    static let identifier = "QnAPostCell"
    
    //MARK: - UIComponents
    private let QLabel = UILabel().then {
        $0.setLabelUI("Q", font: .pretendard_bold, size: 26, color: .black)
    }
    
    private let profileImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .black)
    }
    private let userMarkImageView = UIImageView().then {
        $0.image = UIImage(named: "postMark")
    }
    
    private let dayLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .gray3)
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabelUI("", font: .pretendard_medium, size: 20, color: .black)
    }
    
    private let contentLabel = UILabel().then {
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.setLabelUI("", font: .pretendard_medium, size: 16, color: .black)
    }
    
    lazy var optionButton = UIButton().then {
        $0.setImage(UIImage(named: "verticalOption"), for: .normal)
    }
    
    lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    
    private lazy var pageControl = UIPageControl().then {
        $0.isHidden = true
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        setUpUI()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if userMarkImageView.isHidden {
            dayLabel.snp.makeConstraints {
                $0.centerY.equalTo(profileImageView)
                $0.leading.equalTo(nicknameLabel.snp.trailing).offset(2)
            }
        } else {
            dayLabel.snp.makeConstraints {
                $0.centerY.equalTo(profileImageView)
                $0.leading.equalTo(userMarkImageView.snp.trailing).offset(2)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.customColor(.gray2).cgColor
        layer.cornerRadius = 10
    }
    
    private func setAddView() {
        [
            QLabel,
            profileImageView,
            nicknameLabel,
            userMarkImageView,
            dayLabel,
            titleLabel,
            contentLabel,
            optionButton,
            photoCollectionView,
            pageControl
        ]   .forEach { addSubview($0) }
    }
    
    
    private func setConstraints() {
        
        optionButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16.32)
            make.width.equalTo(10)
        }
        
        QLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(QLabel.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(22)
            make.width.height.equalTo(28)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(29)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        userMarkImageView.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(profileImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(QLabel.snp.bottom).offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(48)
        }
    }
}

extension QnAPostCell {
    func updateCell(_ item: CommunityDetail) {
        profileImageView.kf.setImage(with: URL(string: item.profileImgUrl))
        nicknameLabel.text = item.author
        dayLabel.text = item.time
        titleLabel.text = item.title
        contentLabel.text = item.content
        userMarkImageView.isHidden = !item.writed
    }
    
   func bindPhotoCollectionView(_ photos: [CommunityPhoto]) {
        if !photos.isEmpty {
            
            photoCollectionView.isHidden = false
            pageControl.isHidden = false
            pageControl.numberOfPages = photos.count
            pageControl.pageIndicatorTintColor = .customColor(.gray2)
            pageControl.currentPageIndicatorTintColor = .customColor(.gray4)
            
            photoCollectionView.snp.makeConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(24)
                make.leading.trailing.equalToSuperview().inset(27)
                make.height.equalTo(photoCollectionView.snp.width)
            }
            
            pageControl.snp.makeConstraints { make in
                make.top.equalTo(photoCollectionView.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview().inset(34)
            }
        }
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
   
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = {(item, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            self.pageControl.currentPage = index
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
