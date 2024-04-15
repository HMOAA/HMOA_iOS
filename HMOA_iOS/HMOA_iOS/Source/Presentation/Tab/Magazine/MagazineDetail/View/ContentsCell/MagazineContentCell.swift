//
//  MagazineDetailTitleCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/5/24.
//

import UIKit
import Then
import SnapKit

class MagazineContentCell: UICollectionViewCell {
    
    static let identifier = "MagazineContentCell"
    
    // 화면 스케일에 따른 1픽셀 라인 높이 계산
    let lineHeight: CGFloat = 1 / UIScreen.main.scale
    
    // MARK: - UI Components
    
    private let contentLabel = UILabel().then {
        $0.setLabelUI("콘텐츠", font: .pretendard, size: 14, color: .black)
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.setLineSpacing(lineSpacing: 10)
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
        addSubview(contentLabel)
    }
    
    private func setConstraints() {
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(_ content: MagazineContent) {
        contentLabel.text = content.data
    }
}
