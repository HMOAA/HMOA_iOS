//
//  BrandDetailHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import DropDown

class BrandDetailHeaderView: UICollectionReusableView, View {
    typealias Reactor = BrandDetailHeaderReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()
    
        
    // MARK: identifier
    static let identifier = "BrandDetailHeaderView"
    
    // MARK: - UI Component
    
    lazy var brandInfoView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var brandImageView = UIImageView().then {
        $0.backgroundColor = .customColor(.gray3)
    }
    
    lazy var koreanLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var englishLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .customFont(.pretendard_medium, 14)
    }
    
    lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "bottomHeart"), for: .normal)
    }
    
    
    // TODO: - 드롭다운 라이브러리 사용해서 추후에 구현
    lazy var sortButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitleColor(.black, for: .normal)
//        $0.setTitle("최신순", for: .normal)
    }
    
    lazy var sortDropDown = DropDown()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureDropDown()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrandDetailHeaderView {
    
    // MARK: - bind
    func bind(reactor: BrandDetailHeaderReactor) {
        
        // MARK: - Action
        
        // 정렬 버튼 클릭
        sortButton.rx.tap
            .map { Reactor.Action.didTapSortButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // DropDown 아이템 클릭
        sortDropDown.rx.selectionAction
            .onNext { (index, string) in
                reactor.action.onNext(.didTapSortDropDown(index, string))
            }

        // MARK: - State
        
        // 한글 브랜드명
        reactor.state
            .map { $0.brandInfo.koreanName }
            .distinctUntilChanged()
            .bind(to: koreanLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 영어 브랜드명
        reactor.state
            .map { $0.brandInfo.EnglishName }
            .distinctUntilChanged()
            .bind(to: englishLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 해당 브랜드 좋아요 상태
        reactor.state
            .map { $0.brandInfo.isLikeBrand }
            .distinctUntilChanged()
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // DropDown 보여주기
        reactor.state
            .map { $0.isPresentDropDown }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: {self.sortDropDown.show()})
            .disposed(by: disposeBag)
        
        // sortButton title바꾸기
        reactor.state
            .map { $0.nowSortType }
            .distinctUntilChanged()
            .bind(onNext: {
                self.sortButton.setTitle($0, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func configureUI() {
        
        [   brandInfoView,
            sortButton
        ]   .forEach { addSubview($0) }
        
        [   englishLabel,
            koreanLabel,
            likeButton,
            brandImageView
        ]   .forEach { brandInfoView.addSubview($0) }
        
        
        brandInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        englishLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
        
        koreanLabel.snp.makeConstraints {
            $0.top.equalTo(englishLabel.snp.bottom).offset(6)
            $0.leading.equalTo(englishLabel)
            $0.height.equalTo(14)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        brandImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(100)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(brandInfoView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(80)
        }
    }
    
    func configureDropDown() {
        sortDropDown.dataSource = ["추천순", "인기순", "최신순"]
        sortDropDown.anchorView = self.sortButton
        sortDropDown.bottomOffset = CGPoint(x: -13, y: 30)
        
        sortDropDown.textFont = .customFont(.pretendard_light, 12)
        sortDropDown.selectedTextColor = .black
        sortDropDown.textColor = .customColor(.gray3)
        sortDropDown.selectRow(at: 0)
    }
}
