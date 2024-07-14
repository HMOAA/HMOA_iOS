//
//  HBTISurveyViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/12/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class HBTISurveyViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let progressBar = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .black
        $0.trackTintColor = .customColor(.gray1)
        $0.progress = 0.1
    }
    
    private lazy var hbtiSurveyCollectionView = UICollectionView(
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
    
    func bind(reactor: HBTISurveyReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    private func setAddView() {
        [progressBar,
         hbtiSurveyCollectionView
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        hbtiSurveyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let questionGroup = self.createGroup(estimatedHeight: 20)
            
            let answerGroup = self.createGroup(estimatedHeight: 50)
            
            let combinedGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(300)
            )
            let combinedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: combinedGroupSize,
                subitems: [questionGroup, answerGroup]
            )
            
            let section = NSCollectionLayoutSection(group: combinedGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 8
            
            return section
        }
        return layout
    }
    
    private func createGroup(estimatedHeight height : CGFloat) -> NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        return group
    }
}
