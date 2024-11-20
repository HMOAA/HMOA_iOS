//
//  HBTINotesCategoryViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit
import RxCocoa

final class HBTINotesCategoryViewController: UIViewController, View {
    
    // MARK: - UI Components

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()).then {
            $0.register(
                HBTINotesCategoryCell.self,
                forCellWithReuseIdentifier: HBTINotesCategoryCell.reuseIdentifier
            )
            $0.register(
                HBTINotesCategoryHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HBTINotesCategoryHeaderView.reuseIdentifier
            )
    }
    
    private let nextButton: UIButton = UIButton().makeInvalidNextStepButton(title: "다음")
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<HBTINotesCategorySection, HBTINotesCategoryItem>?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTINotesCategoryReactor) {
        
        // MARK: Action
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { Reactor.Action.didTapNote($0.item + 1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { HBTINotesCategoryReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        Observable
            .combineLatest(
                reactor.state.map { $0.selectedNote }.distinctUntilChanged(),
                reactor.state.map { $0.noteList }.distinctUntilChanged()
            )
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, tuple in
                owner.updateSnapShot(forSection: .category, withItems: tuple.1)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { ($0.recommendedNote, $0.pricePerNote) }
            .distinctUntilChanged { $0.1 == $1.1 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, state in
                guard let headerView = owner.collectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionHeader,
                    at: IndexPath(item: 0, section: 0)
                ) as? HBTINotesCategoryHeaderView else { return }
                
                headerView.configureHeaderViewLabel(bestNote: state.0, pricePerNote: state.1)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnabledNextButton }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
                owner.nextButton.backgroundColor = isEnabled ? .black : .customColor(.gray3)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let selectedNoteList = owner.reactor?.currentState.selectedNote ?? []
                
                owner.presentHBTINotesResultViewController(selectedNoteList)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackToHBTIVCNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         collectionView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: Create Layout
        
    private func createLayout() -> UICollectionViewLayout {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(107))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .estimated(134))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(134))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 24
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16)
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
        
    // MARK: Configure DataSource
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HBTINotesCategorySection, HBTINotesCategoryItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: HBTINotesCategoryItem) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HBTINotesCategoryCell.reuseIdentifier, for: indexPath) as? HBTINotesCategoryCell else {
                return UICollectionViewCell()
            }
            
            switch item {
            case .note(let noteData):
                let selectedNotes = self.reactor?.currentState.selectedNote ?? []
                let noteName = self.reactor?.currentState.recommendedNote ?? ""
                
                cell.configureCell(with: [noteData], selectedNote: selectedNotes, noteName: noteName)
            }
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader,
               let headerView = collectionView.dequeueReusableSupplementaryView(
                   ofKind: kind,
                   withReuseIdentifier: HBTINotesCategoryHeaderView.reuseIdentifier,
                   for: indexPath) as? HBTINotesCategoryHeaderView {
                
                let recommendedNote = self.reactor?.currentState.recommendedNote ?? ""
                let pricePerNote = self.reactor?.currentState.pricePerNote ?? 0
                
                headerView.configureHeaderViewLabel(bestNote: recommendedNote, pricePerNote: pricePerNote)
                
                return headerView
            }
            fatalError("Unexpected element kind or failed to dequeue HBTINotesCategoryHeaderView")
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<HBTINotesCategorySection, HBTINotesCategoryItem>()
        snapshot.appendSections([.category])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func updateSnapShot(forSection section: HBTINotesCategorySection, withItems items: [HBTINotesCategoryItem]) {
        guard let dataSource = self.dataSource else { return }
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
