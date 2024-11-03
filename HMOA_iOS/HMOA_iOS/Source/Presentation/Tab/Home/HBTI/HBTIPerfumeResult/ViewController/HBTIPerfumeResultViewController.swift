//
//  HBTIPerfumeResultViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIPerfumeResultViewController: UIViewController, View {

    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "고객님에게 어울릴 향수는", lineHeight: 27)
    }
    
    private let priceButton = UIButton().then {
        $0.setHBTIPriorityButton(title: "가격대 우선")
        $0.isSelected = true
    }
    
    private let noteButton = UIButton().then {
        $0.setHBTIPriorityButton(title: "향료 우선")
        $0.isSelected = false
    }
    
    private lazy var perfumeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(HBTIPerfumeResultCell.self,
                    forCellWithReuseIdentifier: HBTIPerfumeResultCell.identifier)
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
        $0.isEnabled = true
    }
    
    // MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<HBTIPerfumeResultSection, HBTIPerfumeResultItem>?
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    func bind(reactor: HBTIPerfumeResultReactor) {
        
        // MARK: Action
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceButton.rx.tap
            .map { Reactor.Action.didTapPriorityButton(.price) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        noteButton.rx.tap
            .map { Reactor.Action.didTapPriorityButton(.note) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        perfumeCollectionView.rx.itemSelected
            .map { Reactor.Action.didTapPerfumeCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.resultPriority }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, priority in
                owner.togglePriority(priority)
                
                let items = reactor.currentState.perfumeList
                owner.updateSnapshot(forSection: .perfume, withItems: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.selectedPerfumeID }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, id in
                owner.presentDetailViewController(id)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(onNext: popToHBTIViewController)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
        setBackToHBTIVCNaviBar("향수 추천")
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            titleLabel,
            priceButton,
            noteButton,
            perfumeCollectionView,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.height.equalTo(12)
        }
        
        noteButton.snp.makeConstraints { make in
            make.top.equalTo(priceButton.snp.top)
            make.leading.equalTo(priceButton.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(12)
        }
        
        perfumeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(priceButton.snp.bottom).offset(22)
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
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(354))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.78), heightDimension: .estimated(354))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40)
            section.interGroupSpacing = 16
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: perfumeCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .perfume(let perfume):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTIPerfumeResultCell.identifier,
                    for: indexPath) as! HBTIPerfumeResultCell
                
                cell.configureCell(perfume: perfume)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIPerfumeResultSection, HBTIPerfumeResultItem>()
        initialSnapshot.appendSections([.perfume])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: HBTIPerfumeResultSection, withItems items: [HBTIPerfumeResultItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .perfume))
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func togglePriority(_ priority: ResultPriority) {
        priceButton.isSelected = priority == .price
        noteButton.isSelected = priority == .note
    }
}
