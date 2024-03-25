//
//  MagazineContentsImageCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/19/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MagazineContentsImageCell: UICollectionViewCell {
    
    static let identifier = "MagazineContentsImageCell"
    
    // 화면 스케일에 따른 1픽셀 라인 높이 계산
    let lineHeight: CGFloat = 1 / UIScreen.main.scale
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .random
    }
    
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
        addSubview(imageView)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    func configureCell(_ content: MagazineContent) {
        imageView.kf.setImage(with: URL(string: content.data))
    }
}
