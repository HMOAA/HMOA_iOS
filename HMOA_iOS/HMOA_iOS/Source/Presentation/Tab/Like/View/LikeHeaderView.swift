//
//  LikeHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/01.
//

import UIKit

import SnapKit
import Then

class LikeHeaderView: UICollectionReusableView {
    static let identifier = "LikeHeaderView"
    
    //MARK: Properties
    lazy var cardButton = UIButton().then {
        $0.setImage(UIImage(named: "cardButton"),
                    for: .normal)
        $0.setImage(UIImage(named: "selectedCardButton"),
                    for: .selected)
    }
    
    lazy var listButton = UIButton().then {
        $0.setImage(UIImage(named: "gridButton")
                    , for: .normal)
        $0.setImage(UIImage(named: "selectedGridButton"),
                    for: .selected)
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    func setAddView() {
        [
            cardButton,
            listButton
        ]   .forEach { addSubview($0) }
    }
    
    func setConstraints() {
        cardButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        listButton.snp.makeConstraints { make in
            make.trailing.equalTo(cardButton.snp.leading).offset(-13)
            make.height.equalTo(24)
        }
    }
}
