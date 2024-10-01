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
    
    private let hbtiNotesCategoryTopView = HBTINotesCategoryTopView(labelTexts: HBTICategoryLabelTexts())
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(HBTINotesCategoryCell.self, forCellWithReuseIdentifier: HBTINotesCategoryCell.reuseIdentifier)
    }
    
    private let nextButton: UIButton = UIButton().makeInvalidHBTINextButton()
    
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
        
        collectionView.rx.itemSelected
            .do(onNext: { indexPath in
                let selectedNote = HBTINotesCategoryData.data[indexPath.item]
                let selectedNotes = reactor.currentState.selectedNote
                
                print("===============선택한 노트: \(selectedNote)================\n\n")
                print("===============전체 선택된 노트 배열: \(selectedNotes)================\n")
            })
            .map { Reactor.Action.didTapNote($0.item + 1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.selectedQuantity }
            .distinctUntilChanged()
            .subscribe(onNext: { print("=============Selected Quantity: \($0)============") })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedNote }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, selectedNotes in
                owner.updateSnapShot(withItems: selectedNotes)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         hbtiNotesCategoryTopView,
         collectionView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        hbtiNotesCategoryTopView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(hbtiNotesCategoryTopView.snp.bottom).offset(24)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .estimated(134))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(134))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
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
                cell.configureCell(with: [noteData], selectedNote: selectedNotes)
            }
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<HBTINotesCategorySection, HBTINotesCategoryItem>()
        snapshot.appendSections([.category])
        let items = HBTINotesCategoryData.data.map { HBTINotesCategoryItem.note($0) }
        snapshot.appendItems(items, toSection: .category)
        dataSource?.apply(snapshot, animatingDifferences: false)
    } 

    private func updateSnapShot(withItems items: [Int]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.category])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
