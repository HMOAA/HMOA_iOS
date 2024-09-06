//
//  HBTINoteViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/15/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIPerfumeSurveyViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let progressBar = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .black
        $0.trackTintColor = .customColor(.gray1)
        $0.progress = 0
    }
    
    private lazy var hbtiPerfumeSurveyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(
            HBTISurveyQuestionCell.self,
            forCellWithReuseIdentifier: HBTISurveyQuestionCell.identifier
        )
        $0.register(
            HBTINoteQuestionCell.self,
            forCellWithReuseIdentifier: HBTINoteQuestionCell.identifier
        )
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTIPerfumeSurveySection, HBTIPerfumeSurveyItem>?
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    func bind(reactor: HBTIPerfumeSurveyReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향수 추천")
        hbtiPerfumeSurveyCollectionView.showsVerticalScrollIndicator = false
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            progressBar,
            hbtiPerfumeSurveyCollectionView,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        hbtiPerfumeSurveyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(52)
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .fractionalHeight(1)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 16
            
            return section
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: hbtiPerfumeSurveyCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .price(let question):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTISurveyQuestionCell.identifier,
                    for: indexPath) as! HBTISurveyQuestionCell
                
                cell.configureCell(question: question, answers: question.answers)
                
                return cell
                
            case .note(let question):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTINoteQuestionCell.identifier,
                    for: indexPath) as! HBTINoteQuestionCell
                
                cell.configureCell(question: question)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIPerfumeSurveySection, HBTIPerfumeSurveyItem>()
        initialSnapshot.appendSections([.price, .note])
        
        initialSnapshot.appendItems([
            .price(HBTIQuestion(id: 1, content: "시험용", answers: [HBTIAnswer(id: 1, content: "시험")], isMultipleChoice: false)),
            .note(HBTINoteQuestion(content: "시향 후 마음에 드는 향료를 골라주세요", isMultipleChoice: true, answer: []))
        ])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }

}
