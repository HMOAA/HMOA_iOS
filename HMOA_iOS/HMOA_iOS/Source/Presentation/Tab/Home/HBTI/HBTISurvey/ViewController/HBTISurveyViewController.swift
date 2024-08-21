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

final class HBTISurveyViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let progressBar = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .black
        $0.trackTintColor = .customColor(.gray1)
        $0.progress = 0
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
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.questionList }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .question, withItems: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedID }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, selectedID in
                let progress = Float(selectedID.count) / Float(reactor.currentState.questionList.count)
                owner.progressBar.setProgress(progress, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.currentQuestion }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, row in
                let indexPath = IndexPath(row: row, section: 0)
                owner.hbtiSurveyCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isEnableNextButton }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
                owner.nextButton.backgroundColor = isEnabled ? .black : UIColor.customColor(.gray3)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(onNext: presentHBTISurveyResultViewController)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
        hbtiSurveyCollectionView.isScrollEnabled = true
        hbtiSurveyCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 92, right: 0)
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
            make.horizontalEdges.bottom.equalToSuperview()
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
            
            var previousPage: Int = -1
            section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in
                let currentPage = Int(max(0, round(offset.x / env.container.contentSize.width)))
                if currentPage != previousPage {
                    previousPage = currentPage
                    self.reactor?.action.onNext(.didChangeQuestion(currentPage))
                }
            }
            
            return section
        }
        return layout
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
                
                for (i, view) in cell.answerStackView.subviews.enumerated() {
                    guard i < question.answers.count else { break }
                    
                    let button = view as! UIButton
                    let answerID = question.answers[i].id
                    
                    button.rx.tap
                        .map { Reactor.Action.didTapAnswerButton((question, answerID)) }
                        .bind(to: self.reactor!.action)
                        .disposed(by: self.disposeBag)
                    
                    self.reactor?.state
                        .map {
                            guard let selectedID = $0.selectedID[question.id] else { return false }
                            return selectedID.contains(answerID)
                        }
                        .bind(to: button.rx.isSelected)
                        .disposed(by: cell.disposeBag)
                }
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTISurveySection, HBTISurveyItem>()
        initialSnapshot.appendSections([.question])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: HBTISurveySection, withItems items: [HBTISurveyItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
