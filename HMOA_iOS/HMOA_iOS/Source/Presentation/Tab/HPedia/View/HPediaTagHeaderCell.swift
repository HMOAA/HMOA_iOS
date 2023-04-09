//
//  HPediaTagHeaderCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/09.
//

import UIKit

import Then
import TagListView
import SnapKit

class HPediaTagHeaderCell: UICollectionReusableView {
    
    static let identifier = "HPediaTagHeaderCell"
    
    //MAKR: - Properties
    let menuTagListView = TagListView(frame: CGRect(x: 0, y: 0, width: 100, height: 32)).then {
        $0.textFont = .customFont(.pretendard_light, 16)
        $0.tagSelectedBackgroundColor = .black
        $0.selectedTextColor = .white
        $0.addTags(["브랜드", "노트", "용어"])
        $0.alignment = .leading
        $0.marginX = 8
        $0.paddingY = 8
        $0.paddingX = 16
        $0.tagBackgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        $0.cornerRadius = 16
        $0.textColor = .black
    }
    
    let tagViewAllButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitle("전체보기", for: .normal)
    }
    
    //MAKR: - LifeCycle
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setAddView() {
        [
            menuTagListView,
            tagViewAllButton
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        
        menuTagListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        tagViewAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
