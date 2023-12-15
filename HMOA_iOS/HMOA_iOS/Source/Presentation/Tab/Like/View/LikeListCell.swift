//
//  LikeListCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/16.
//

import UIKit

import SnapKit
import Then

class LikeListCell: UICollectionViewCell {
    
    static let identifier = "LikeListCell"

    //MARK: - Property
    let perpumeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let heartButton = UIButton().then {
        $0.setImage(UIImage(named: "drawerSelected"), for: .normal)
    }
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.customColor(.gray2).cgColor
    }
    private func setAddView() {
        [perpumeImageView,
         heartButton].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        perpumeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8.78)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(14)
            make.height.equalTo(12.44)
        }
    }
    
}

extension LikeListCell {
    func updateCell(item: Like) {
        perpumeImageView.kf.setImage(with: URL(string: item.perfumeImageUrl))
    }
}
