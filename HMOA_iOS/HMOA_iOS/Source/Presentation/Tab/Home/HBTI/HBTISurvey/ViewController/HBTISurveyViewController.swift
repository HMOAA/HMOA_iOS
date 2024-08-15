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
    ).then {
        $0.register(
            HBTISurveyQuestionCell.self,
            forCellWithReuseIdentifier: HBTISurveyQuestionCell.identifier
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
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTISurveySection, HBTISurveyItem>?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTISurveyReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
        hbtiSurveyCollectionView.isScrollEnabled = false
    }
    
    // MARK: Add Views
    private func setAddView() {
        [progressBar,
         hbtiSurveyCollectionView,
         nextButton
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
            make.bottom.equalTo(nextButton.snp.top)
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
                heightDimension: .estimated(300)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .estimated(300)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 16
            
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
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: hbtiSurveyCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .question(let question):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTISurveyQuestionCell.identifier,
                    for: indexPath) as! HBTISurveyQuestionCell
                
                cell.configureCell(question: question, answers: question.answers)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTISurveySection, HBTISurveyItem>()
        initialSnapshot.appendSections([.question])
        
        // TODO: API 연동 후 삭제
        initialSnapshot.appendItems([
            .question(HBTIQuestion(
                id: 1,
                content: "좋아하는 계절이 있으신가요?",
                answers: [
                    HBTIAnswer(id: 1, content: "싱그럽고 활기찬 ‘봄’"),
                    HBTIAnswer(id: 2, content: "화창하고 에너지 넘치는 ‘여름’"),
                    HBTIAnswer(id: 3, content: "우아하고 고요한 분위기의 ‘가을’"),
                    HBTIAnswer(id: 4, content: "차가움과 아늑함이 공존하는 ‘겨울’")
                ]
            )),
            .question(HBTIQuestion(
                id: 2,
                content: "남들이 생각하는 본인의 이미지는 무엇인가요?",
                answers: [
                    HBTIAnswer(id: 5, content: "청순"),
                    HBTIAnswer(id: 6, content: "시크, 멋짐"),
                    HBTIAnswer(id: 7, content: "단아"),
                    HBTIAnswer(id: 8, content: "귀여움"),
                    HBTIAnswer(id: 9, content: "섹시")
                ]
            ))
        ], toSection: .question)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}
