//
//  QnAListHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/08.
//

import UIKit

import Then
import SnapKit
import TagListView

class QnAListHeaderView: UICollectionReusableView {
    
    static let identifier = "QnAListHeaderView"
    
    let tagListView = TagListView(frame: .zero).then {
        $0.alignment = .leading
        $0.marginX = 8
        $0.paddingY = 4
        $0.paddingX = 12
        $0.cornerRadius = 11
        $0.tagBackgroundColor = .customColor(.gray2)
        $0.tagSelectedBackgroundColor = .black
        $0.addTags(["추천", "선물", "자유"])
        $0.textColor = .white
        $0.textFont = .customFont(.pretendard, 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        setAddView()
        setConstraints()
        tagListView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        layer.addBorder([.bottom], color: .customColor(.gray2), width: 1)
    }
    private func setAddView() {
        self.addSubview(tagListView)
    }
    
    private func setConstraints() {
        tagListView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

extension QnAListHeaderView: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListView.tagViews.forEach {
            if $0 != tagView { $0.isSelected = false }
        }
    }
}
