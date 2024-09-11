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
        
        nextButton.rx.tap
            .map { Reactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.isEnabledNextButton }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
                owner.nextButton.backgroundColor = isEnabled ? .black : UIColor.customColor(.gray3)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.currentPage }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, row in
                if owner.hbtiPerfumeSurveyCollectionView.numberOfItems(inSection: 0) > 0 {
                    let indexPath = IndexPath(row: row, section: 0)
                    owner.hbtiPerfumeSurveyCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향수 추천")
        hbtiPerfumeSurveyCollectionView.showsVerticalScrollIndicator = false
        hbtiPerfumeSurveyCollectionView.isScrollEnabled = false
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
            make.top.equalTo(progressBar.snp.bottom).offset(24)
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
                widthDimension: .fractionalWidth(1),
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
                    self.reactor?.action.onNext(.didChangePage(currentPage))
                }
            }
            
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
                
                for (i, view) in cell.answerStackView.subviews.enumerated() {
                    guard i < question.answers.count else { break }
                    
                    let button = view as! UIButton
                    let priceInfo = question.answers[i].content
                    
                    button.rx.tap
                        .map { Reactor.Action.didTapPriceButton(priceInfo) }
                        .bind(to: self.reactor!.action)
                        .disposed(by: self.disposeBag)
                    
                    self.reactor?.state
                        .map {
                            guard let selectedPrice = $0.selectedPrice else { return false }
                            return selectedPrice == priceInfo
                        }
                        .bind(to: button.rx.isSelected)
                        .disposed(by: cell.disposeBag)
                }
                
                return cell
                
            case .note(let note):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTINoteQuestionCell.identifier,
                    for: indexPath) as! HBTINoteQuestionCell
                
                cell.configureCell(question: note)
                
                self.reactor?.state
                    .map { $0.noteList }
                    .distinctUntilChanged()
                    .asDriver(onErrorRecover: { _ in .empty() })
                    .drive(with: self, onNext: { owner, noteList in
                        cell.updateSnapshot(withNoteAnswers: noteList)
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIPerfumeSurveySection, HBTIPerfumeSurveyItem>()
        initialSnapshot.appendSections([.survey])
        
        initialSnapshot.appendItems([
            .price(HBTIQuestion(id: 1, content: "시험용", answers: [HBTIAnswer(id: 1, content: "가격1"), HBTIAnswer(id: 2, content: "가격2")], isMultipleChoice: false)),
            .note(HBTINoteQuestion(content: "시향 후 마음에 드는 향료를 골라주세요", isMultipleChoice: true, answer: []))
        ])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }

}
