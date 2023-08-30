//
//  DrawerViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import ReactorKit

class LikeViewController: UIViewController, View {
    
    //MARK: - Property

    //TODO: - 임시로 이미지 집어넣었으므로 나중에 바꿔주기
    let cardButton = UIButton().then {
        $0.isSelected = true
        $0.setImage(UIImage(named: "cardButton"),
                    for: .normal)
        $0.setImage(UIImage(named: "selectedCardButton"),
                    for: .selected)
    }
    
    let listButton = UIButton().then {
        $0.setImage(UIImage(named: "gridButton")
                    , for: .normal)
        $0.setImage(UIImage(named: "selectedGridButton"),
                    for: .selected)
    }
    
    let reactor = LikeReactor()
    var disposeBag = DisposeBag()
    
    private var cardDatasource: UICollectionViewDiffableDataSource<LikeSection, Like>!
    private var listDatasource: UICollectionViewDiffableDataSource<LikeSection, Like>!

    
    lazy var cardCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: configureCardLayout()).then {
        $0.alwaysBounceVertical = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(LikeCardCell.self,
                    forCellWithReuseIdentifier: LikeCardCell.identifier)
    }
    
    lazy var listCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureListLayout()).then {
        $0.register(LikeListCell.self, forCellWithReuseIdentifier: LikeListCell.identifier)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        
        configureCardDataSource()
        configureListDataSource()
        
        bind(reactor: reactor)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = UIColor.white
        setNavigationColor()
        setNavigationBarTitle("저장")
    }
    
    private func setAddView() {
        [cardButton,
         listButton,
         cardCollectionView,
         listCollectionView].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        cardButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(17.5)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(19)
            make.height.equalTo(24)
        }
        
        listButton.snp.makeConstraints { make in
            make.trailing.equalTo(cardButton.snp.leading).offset(-13)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(19)
            make.height.equalTo(24)
        }
        
        cardCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(354).priority(751)
            make.top.equalTo(listButton.snp.bottom).offset(23)
            make.bottom.equalToSuperview()
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listButton.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    //MARK: - Bind
    func bind(reactor: LikeReactor) {
        
        //Input
        rx.viewWillAppear
            .map { _ in LikeReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //카드버튼 터치 이벤트
        cardButton.rx.tap
            .map { LikeReactor.Action.didTapCardButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //리스트 버튼 터치 이벤트
        listButton.rx.tap
            .map { LikeReactor.Action.didTapListButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cardCollectionView.rx.itemSelected
            .map { LikeReactor.Action.didTapCollectionViewItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        listCollectionView.rx.itemSelected
            .map { LikeReactor.Action.didTapCollectionViewItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //Output
        
        //CollectionView Binding
        reactor.state
            .map { $0.sectionItem }
            .distinctUntilChanged()
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
                print(item)
                var cardSnapshot = NSDiffableDataSourceSnapshot<LikeSection, Like>()
                cardSnapshot.appendSections([.main])
                cardSnapshot.appendItems(item, toSection: .main)
                
                var listSnapshot = NSDiffableDataSourceSnapshot<LikeSection, Like>()
                listSnapshot.appendSections([.main])
                listSnapshot.appendItems(item, toSection: .main)
                
                DispatchQueue.main.async {
                    self.cardDatasource.apply(cardSnapshot)
                    self.listDatasource.apply(listSnapshot)
                }
            })
            .disposed(by: disposeBag)
        
        //cardCollectionView 보여주기
        reactor.state
            .map { $0.isSelectedCard }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, result in
                owner.listCollectionView.isHidden = result
                owner.cardCollectionView.isHidden = !result
                owner.cardButton.isSelected = result
                owner.listButton.isSelected = !result
            })
            .disposed(by: disposeBag)
        
        //listCollectionView 보여주기
        reactor.state
            .map { $0.isSelectedList }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, result in
                owner.listCollectionView.isHidden = !result
                owner.cardCollectionView.isHidden = result
                owner.cardButton.isSelected = !result
                owner.listButton.isSelected = result
                
            })
            .disposed(by: disposeBag)
        

        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
      
    }
    
}

extension LikeViewController {
    
    func configureCardDataSource() {
        cardDatasource = UICollectionViewDiffableDataSource<LikeSection, Like>(collectionView: cardCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCardCell.identifier, for: indexPath) as? LikeCardCell
            else { return UICollectionViewCell() }
            
            cell.updateCell(item: item)
            return cell
        })
    }
    
    func configureListDataSource() {
        listDatasource = UICollectionViewDiffableDataSource<LikeSection, Like> (collectionView: listCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeListCell.identifier, for: indexPath) as? LikeListCell
            else { return UICollectionViewCell() }
            
            cell.updateCell(item: item)
            return cell
        })
        
    }
    
    private func configureCardLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(354))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.79), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureListLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.23))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

