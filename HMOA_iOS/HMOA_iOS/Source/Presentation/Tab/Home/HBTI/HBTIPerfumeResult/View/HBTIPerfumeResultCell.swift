//
//  HBTIPerfumeResultCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import UIKit

import SnapKit
import Then
import RxSwift

class HBTIPerfumeResultCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    static let identifier = "HBTIPerfumeResultCell"
    
    private let topView = UIView().then {
        $0.backgroundColor = .black
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
        
        setUI()
        setAddView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    //MARK: - SetUp
    private func setUI() {
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    private func setAddView() {
        
        addSubview(shadowView)
        
        [brandNameLabel].forEach { topView.addSubview($0) }
        
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
        
        brandNameLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        perpumeImageView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(24)
            make.top.equalTo(perpumeImageView.snp.bottom).offset(46)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(24)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(28)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    func configureCell(perfume: HBTIPerfume) {
        brandNameLabel.text = "브랜드"
        korNameLabel.text = perfume.nameKR
        engNameLabel.text = perfume.nameEN
        priceLabel.text = perfume.price.numberFormatterToWon()
        //        perpumeImageView.kf.setImage(with: URL(string: item.perfumeImageUrl))
        perpumeImageView.backgroundColor = .random
    }
    
}
