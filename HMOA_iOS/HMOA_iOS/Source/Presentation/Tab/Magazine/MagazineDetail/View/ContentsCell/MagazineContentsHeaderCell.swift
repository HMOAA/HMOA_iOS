//
//  MagazineContentsHeaderCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/19/24.
//

import UIKit
import SnapKit
import Then

class MagazineContentsHeaderCell: UICollectionViewCell {
    
    static let identifier = "MagazineContentsHeaderCell"
    
    // 화면 스케일에 따른 1픽셀 라인 높이 계산
    let lineHeight: CGFloat = 1 / UIScreen.main.scale
    
    // MARK: - UI Components
    
    // 헤더 라벨
    private let headerLabel = UILabel().then {
        $0.setLabelUI("헤더", font: .pretendard_bold, size: 20, color: .black)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
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
        addSubview(headerLabel)
    }
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ content: MagazineContents) {
        headerLabel.text = content.data
    }
}
