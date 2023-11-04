//
//  PhotoCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/11/01.
//

import UIKit

import Then
import SnapKit
import RxSwift

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properites
    static let identifier = "PhotoCell"
    
    var disposeBag = DisposeBag()
    
    
    //MARK: - UI Components
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let countLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 16)
    }
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    //MARK: - SetUp
    
    private func setAddView() {
        [
            imageView,
            countLabel
        ]   .forEach { addSubview($0) }
        
    }
    
    private func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(15)
        }
    }
    
    func updateCell(_ image: UIImage, _ row: Int) {
        imageView.image = image
        countLabel.text = "\(row + 1)/6"
    }
}
