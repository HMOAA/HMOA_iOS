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
import RxDataSources

class LikeViewController: UIViewController {
    
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
    let disposeBag = DisposeBag()
    private var cardDatasource: RxCollectionViewSectionedReloadDataSource<CardSection>!
    private var listDatasource: RxCollectionViewSectionedReloadDataSource<ListSection>!
    
    lazy var cardCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: configureCardLayout()).then {
        $0.alwaysBounceVertical = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(LikeCardCell.self,
                    forCellWithReuseIdentifier: LikeCardCell.identifier)
        $0.isHidden = true
    }
    
    lazy var listCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureListLayout()).then {
        $0.register(LikeListCell.self, forCellWithReuseIdentifier: LikeListCell.identifier)
        //$0.isHidden = true
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
        setNavigationBarTitle(title: "저장",
                              color: .white,
                              isHidden: true,
                              isScroll: false)
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
            make.bottom.equalTo(cardCollectionView.snp.top).offset(-23)
            make.height.equalTo(20)
        }
        
        listButton.snp.makeConstraints { make in
            make.trailing.equalTo(cardButton.snp.leading).offset(-13)
            make.bottom.equalTo(cardCollectionView.snp.top).offset(-23)
            make.height.equalTo(18)
        }
        
        cardCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(357)
            make.centerY.equalToSuperview()
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listButton.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureCardDataSource() {
        cardDatasource = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCardCell.identifier, for: indexPath) as? LikeCardCell
            else { return UICollectionViewCell() }
            
            cell.configure(item: item)
            return cell
        })
        
    }
    
    func configureListDataSource() {
        listDatasource = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeListCell.identifier, for: indexPath) as? LikeListCell
            else { return UICollectionViewCell() }
            
            cell.perpumeImageView.image = UIImage(named: item.imgName)
            return cell
        })
        
    }
    
    private func bind(reactor: LikeReactor) {
        
        reactor.state
            .map { $0.cardSections }
            .bind(to: cardCollectionView.rx.items(dataSource: cardDatasource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.listSections }
            .bind(to: listCollectionView.rx.items(dataSource: listDatasource))
            .disposed(by: disposeBag)
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

