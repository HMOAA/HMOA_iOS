//
//  CardCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/16.
//

import UIKit

import SnapKit
import Then
import RxDataSources
import RxCocoa
import ReactorKit

class LikeCardCell: UICollectionViewCell {
    
    // MARK: - Property
    static let identifier = "LikeCardCell"
    
    let topView = UIView().then {
        $0.backgroundColor = .black
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    let brandNameLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard_medium,
                      size: 14,
                      color: .white)
    }
    
    let perpumeImageView = UIImageView().then {
        $0.image = UIImage(named: "jomalon")
    }
    
    let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 50, height: 18)
        $0.minimumLineSpacing = 4
        $0.scrollDirection = .horizontal
    }
    
    lazy var tagCollectionView = UICollectionView(frame: .zero,
                                        collectionViewLayout: layout).then {
        $0.isScrollEnabled = false
        $0.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    let nameStackView = UIStackView().then {
        $0.setStackViewUI(spacing: 8)
    }
    let korNameLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard, size: 14, color: .black)
    }
    
    let engNameLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard,
                      size: 12,
                      color: .black)
    }
    
    let priceTextLabel = UILabel().then {
        $0.setLabelUI("Price",
                      font: .pretendard,
                      size: 14,
                      color: .black)
    }
    
    let priceLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard,
                      size: 14,
                      color: .black)
    }
    
    let reacotr = TagReactor()
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func layoutSubviews() {
        super .layoutSubviews()
        setUpUI()
    }
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
        
        bind(reactor: reacotr)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - SetUp
    private func setUpUI() {
        backgroundColor = .white
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    private func setAddView() {
        [xButton,
         brandNameLabel].forEach { topView.addSubview($0) }
        
        [
         korNameLabel,
         engNameLabel].forEach { nameStackView.addArrangedSubview($0) }
        
        [topView,
         perpumeImageView,
         tagCollectionView,
         nameStackView,
         priceTextLabel,
         priceLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21)
            make.centerY.equalToSuperview()
        }
        
        brandNameLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        perpumeImageView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(18)
            make.top.equalTo(perpumeImageView.snp.bottom).offset(20)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(24)
            make.top.equalTo(tagCollectionView.snp.bottom).offset(8)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(28)
            make.bottom.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(24)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(28)
            make.bottom.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func bind(reactor: TagReactor) {
        reactor.state
            .map { $0.sections }
            .bind(to: tagCollectionView.rx.items(cellIdentifier: TagCell.identifier,
                                            cellType: TagCell.self)) { ( _, element, cell) in
                cell.tagLabel.text = element
            }.disposed(by: disposeBag)
    }
    
    func configure(item: CardSection.Item) {
        brandNameLabel.text = item.brandName
        korNameLabel.text = item.korPerpumeName
        engNameLabel.text = item.engPerpumeName
        priceLabel.text = item.price.numberFormatterToWon()
    }
    
}
