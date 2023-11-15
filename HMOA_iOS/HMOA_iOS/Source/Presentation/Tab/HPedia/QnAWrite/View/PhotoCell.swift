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
        $0.contentMode = .scaleAspectFit
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
            imageView
        ]   .forEach { addSubview($0) }
        
    }
    
    private func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateCell(_ image: UIImage) {
        imageView.image = image
    }
}
