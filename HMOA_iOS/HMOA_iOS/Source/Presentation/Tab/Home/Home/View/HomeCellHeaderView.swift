//
//  HomeCellHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift

class HomeCellHeaderView: UICollectionReusableView, View{
    typealias Reactor = HomeHeaderReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - identifier
    
    static let identifier = "HomeCellHeaderView"
    
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 16)
    }
    
    private lazy var moreButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel!.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCellHeaderView {
    private func configureUI() {
        [   titleLabel,
            moreButton  ] .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
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
        
        reactor.state
            .map { $0.listType }
            .distinctUntilChanged()
            .compactMap { $0 }
            .map { $0 == 0 }
            .bind(to: moreButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
