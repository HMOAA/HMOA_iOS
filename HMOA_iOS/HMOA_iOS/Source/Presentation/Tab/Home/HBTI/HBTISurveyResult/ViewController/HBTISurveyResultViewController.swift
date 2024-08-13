//
//  HBTISurveyResultViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/12/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class HBTISurveyResultViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let loadingView = HBTILoadingView()
    
    private let bestLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "OOO님에게 딱 맞는 향료는\n'시트러스'입니다", lineHeight: 27)
        $0.numberOfLines = 2
    }
    
    private let secondThirdLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .gray3)
        $0.setTextWithLineHeight(text: "2위: 플로럴\n3위: 스파이스", lineHeight: 20)
        $0.numberOfLines = 2
    }
    
    private lazy var hbtiSurveyResultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTISurveyResultReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setBackItemNaviBar("향BTI")
        loadingView.isHidden = true
    }
    
    // MARK: Add Views
    private func setAddView() {
        // 로딩 화면
        view.addSubview(loadingView)
        
        // 결과 화면
        [
            bestLabel,
            secondThirdLabel
        ] .forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        bestLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
        }
        
        secondThirdLabel.snp.makeConstraints { make in
            make.top.equalTo(bestLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let bannerWidthRatio = 249.0 / 360.0
            let bannerHeight = 333.0 / 249.0 * bannerWidthRatio
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(bannerHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(bannerWidthRatio),
                heightDimension: .estimated(bannerHeight)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 16
            
            return section
        }
        return layout
    }
}
