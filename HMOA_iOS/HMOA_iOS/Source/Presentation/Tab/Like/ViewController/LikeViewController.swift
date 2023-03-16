//
//  DrawerViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

import SnapKit
import Then

class LikeViewController: UIViewController {
    
    //MARK: - Property

    //TODO: - 임시로 이미지 집어넣었으므로 나중에 바꿔주기
    let listButton = UIButton().then {
        $0.setImage(UIImage(systemName: "rectangle.split.3x3"), for: .normal)
        $0.setImage(UIImage(systemName: "rectangle.split.3x3.fill"), for: .selected)
    }
    
    let cardButton = UIButton().then {
        $0.setImage(UIImage(systemName: "lanyardcard"), for: .normal)
        $0.setImage(UIImage(systemName: "lanyardcard.fill"), for: .selected)
    }
    
    let cardCollectionView = UICollectionView()
    
    let listCollectionView = UICollectionView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor.white
        setNavigationBarTitle(title: "저장", color: .white, isHidden: true, isScroll: false)
    }
    
    private func setConstraints() {
        cardButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(17.5)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.bottom.equalTo(cardCollectionView.snp.top).offset(-23)
        }
        
        listButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.trailing.equalTo(cardButton.snp.leading).offset(13)
            make.bottom.equalTo(cardCollectionView.snp.top).offset(-23)
        }
        
        cardCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(354)
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listButton.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
