//
//  HomeWatchCellHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/19.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class HomeFirstCellHeaderView: UICollectionReusableView, View {
    typealias Reactor = HomeHeaderReactor
    
    // MARK: - identifier
    static let identifier = "HomeFirstCellHeaderView"
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()

    let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel!.font = .customFont(.pretendard, 12)
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        configureUI()
    }
}

// MARK: - Functions

extension HomeFirstCellHeaderView {
    func configureUI() {
        
        [   titleLabel,
            moreButton  ] .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bind(reactor: HomeHeaderReactor) {
        
        // MARK: - Action
        
        // 전체보기 버튼 클릭
        moreButton.rx.tap
            .map { Reactor.Action.didTapMoreButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
    
        // headerTitle titleLabel에 바인딩
        reactor.state
            .map { $0.headerTitle }
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
