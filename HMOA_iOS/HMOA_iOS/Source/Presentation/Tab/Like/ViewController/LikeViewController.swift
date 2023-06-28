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
    let listButton = UIButton().then {
        $0.setImage(UIImage(systemName: "rectangle.split.3x3"),
                    for: .normal)
        $0.setImage(UIImage(systemName: "rectangle.split.3x3.fill"),
                    for: .selected)
    }
    
    let cardButton = UIButton().then {
        $0.isSelected = true
        $0.setImage(UIImage(systemName: "lanyardcard")
                    , for: .normal)
        $0.setImage(UIImage(systemName: "lanyardcard.fill"),
                    for: .selected)
    }
    
    let reactor = LikeReactor()
    var disposeBag = DisposeBag()
    
    private var cardDatasource: UICollectionViewDiffableDataSource<CardSection, CardSectionItem>?
    private var listDatasource: UICollectionViewDiffableDataSource<ListSection, ListSectionItem>?

    
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
            make.height.equalTo(18)
        }
        
        listButton.snp.makeConstraints { make in
            make.trailing.equalTo(cardButton.snp.leading).offset(-13)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(19)
            make.height.equalTo(18)
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
        
        //Output
        
        //cardCollectionView Binding
        reactor.state
            .map { $0.cardSectionItem }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, cards in
                guard let datasource = owner.cardDatasource else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<CardSection, CardSectionItem>()
                snapshot.appendSections([.main])
                snapshot.appendItems(cards, toSection: .main)
                
                DispatchQueue.main.async {
                    datasource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
        
        //listCollectionView Binding
        reactor.state
            .map { $0.listSectionItem }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, lists in
                guard let datasource = owner.listDatasource else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<ListSection, ListSectionItem>()
                snapshot.appendSections([.main])
                snapshot.appendItems(lists, toSection: .main)
                
                DispatchQueue.main.async {
                    datasource.apply(snapshot)
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
      
    }
    
}

extension LikeViewController {
    
    func configureCardDataSource() {
        cardDatasource = UICollectionViewDiffableDataSource<CardSection, CardSectionItem>(collectionView: cardCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCardCell.identifier, for: indexPath) as? LikeCardCell
            else { return UICollectionViewCell() }
            
            cell.configure(item: item)
            return cell
        })
    }
    
    func configureListDataSource() {
        listDatasource = UICollectionViewDiffableDataSource<ListSection, ListSectionItem> (collectionView: listCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeListCell.identifier, for: indexPath) as? LikeListCell
            else { return UICollectionViewCell() }
            
            cell.perpumeImageView.image = UIImage(named: item.imgName)
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

