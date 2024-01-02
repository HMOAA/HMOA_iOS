//
//  CardCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/16.
//

import UIKit

import SnapKit
import Then
import RxSwift

class LikeCardCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    static let identifier = "LikeCardCell"
    
    private let topView = UIView().then {
        $0.backgroundColor = .black
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    private let brandNameLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard_medium,
                      size: 14,
                      color: .white)
    }
    
    private let perpumeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 50, height: 18)
        $0.minimumLineSpacing = 4
        $0.scrollDirection = .horizontal
    }
    
    private let nameStackView = UIStackView().then {
        $0.distribution = .fillProportionally
        $0.setStackViewUI(spacing: 8)
    }
    private let korNameLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard, size: 14, color: .black)
    }
    
    private let engNameLabel = UILabel().then {
        $0.sizeToFit()
        
        $0.setLabelUI("",
                      font: .pretendard,
                      size: 12,
                      color: .black)
    }
    
    private let priceTextLabel = UILabel().then {
        $0.setLabelUI("Price",
                      font: .pretendard,
                      size: 14,
                      color: .black)
    }
    
    private let priceLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard,
                      size: 14,
                      color: .black)
    }
    
    private let shadowView = UIView().then {
        
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
        $0.layer.shadowRadius = 1
        $0.layer.masksToBounds = false
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    //MARK: - SetUp
    private func setAddView() {
        
        addSubview(shadowView)
        
        [xButton,
         brandNameLabel].forEach { topView.addSubview($0) }
        
        [
         korNameLabel,
         engNameLabel].forEach { nameStackView.addArrangedSubview($0) }
        
        [topView,
         perpumeImageView,
         nameStackView,
         priceTextLabel,
         priceLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        brandNameLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        perpumeImageView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(250)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(24)
            make.top.equalTo(perpumeImageView.snp.bottom).offset(8)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(36)
            make.leading.equalToSuperview().inset(24)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(36)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func updateCell(item: Like) {
        brandNameLabel.text = item.brandName
        korNameLabel.text = item.koreanName
        engNameLabel.text = item.englishName
        priceLabel.text = item.price.numberFormatterToWon()
        perpumeImageView.kf.setImage(with: URL(string: item.perfumeImageUrl))
    }

    
}
