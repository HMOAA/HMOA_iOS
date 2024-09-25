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
            .compactMap { $0.questionList }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .survey, withItems: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { ($0.selectedPrice, $0.selectedNoteList) }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { (owner, option) in
                owner.updateProgressbar(option, owner)
            })
            .disposed(by: disposeBag)
        
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
        
        reactor.state
            .map { $0.isPushNextVC }
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isPush in
                let selectedPrice = reactor.currentState.selectedPrice!
                let (min, max) = owner.parsePriceRange(priceInfo: selectedPrice)
                let notes = reactor.currentState.selectedNoteList.map { $0.0 }
                
                owner.presentHBTIPerfumeResultViewController(min, max, notes)
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
                
                cell.noteCategoryCollectionView.rx.itemSelected
                    .map { Reactor.Action.isSelectedNoteItem($0) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                cell.noteCategoryCollectionView.rx.itemDeselected
                    .map { Reactor.Action.isDeselectedNoteItem($0) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                self.reactor?.state
                    .map { $0.selectedNoteList }
                    .asDriver(onErrorRecover: { _ in .empty()})
                    .drive(with: self, onNext: { owner, selectedNoteList in
                        cell.selectedNoteView.updateSnapshot(with: selectedNoteList.map { $0.0 })
                        cell.updateHeight(condition: selectedNoteList.isEmpty)
                        owner.deselectRemovedItems(from: selectedNoteList,
                                                   in: cell.noteCategoryCollectionView)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.selectedNoteView.selectedNoteCollectionView.rx.willDisplayCell
                    .asDriver(onErrorRecover: { _ in .empty() })
                    .drive(onNext: { cell, _ in
                        guard let subCell = cell as? HBTISelectedNoteCell else { return }
                        guard let note = subCell.tagLabel.text else { return }
                        
                        subCell.bindButtonAction()
                            .map { Reactor.Action.didTapCancelButton(note) }
                            .bind(to: self.reactor!.action)
                            .disposed(by: subCell.disposeBag)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.selectedNoteView.clearButton.rx.tap
                    .map { Reactor.Action.didTapClearButton }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIPerfumeSurveySection, HBTIPerfumeSurveyItem>()
        initialSnapshot.appendSections([.survey])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: HBTIPerfumeSurveySection, withItems items: [HBTIPerfumeSurveyItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems([.price(items[0].price!), .note(items[1].note!)])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension HBTIPerfumeSurveyViewController {
    func deselectRemovedItems(from noteList: [(String, IndexPath)], in collectionView: UICollectionView) {
        let canceledNoteCellIndexPathList = collectionView.indexPathsForSelectedItems?.filter {
            let indexPathList = noteList.map { $0.1 }
            return !indexPathList.contains($0)
        }
        
        if let indexPathList = canceledNoteCellIndexPathList {
            for indexPath in indexPathList {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
    
    func updateProgressbar(_ option: (String?, [(String, IndexPath)]), _ owner: HBTIPerfumeSurveyViewController) {
        let (price, noteList) = option
        var progress: Float = 0
        
        if price != nil && !noteList.isEmpty {
            progress = 1
        } else if price != nil || !noteList.isEmpty {
            progress = 0.5
        } else {
            progress = 0
        }
        owner.progressBar.setProgress(progress, animated: true)
    }
    
    private func parsePriceRange(priceInfo: String) -> (Int, Int) {
        let selectedPrice = priceInfo
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "원", with: "")
            .split(separator: " ")
        
        var (min, max) = (0, 1_000_000)
        switch selectedPrice[1] {
        case "이하":
            max = Int(selectedPrice[0]) ?? 1_000_000
        case "~":
            min = Int(selectedPrice[0]) ?? 0
            max = Int(selectedPrice[2]) ?? 1_000_000
        case "이상":
            min = Int(selectedPrice[0]) ?? 0
        default: break
        }
        
        return (min, max)
    }
}
