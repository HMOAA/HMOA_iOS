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
        $0.setImage(UIImage(systemName: "lanyardcard")
                    , for: .normal)
        $0.setImage(UIImage(systemName: "lanyardcard.fill"),
                    for: .selected)
    }
    
    let reactor = LikeReactor()
    let disposeBag = DisposeBag()
    private var datasource: RxCollectionViewSectionedReloadDataSource<CardSection>!
    
    lazy var cardCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: configureLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(LikeCardCell.self,
                    forCellWithReuseIdentifier: LikeCardCell.identifier)
    }
    
    //let listCollectionView = UICollectionView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        
        configureDataSource()
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
         cardCollectionView].forEach { view.addSubview($0) }
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
        
//        listCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(listButton.snp.bottom).offset(19)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview()
//        }
    }
    
    func configureDataSource() {
        datasource = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeCardCell.identifier, for: indexPath) as? LikeCardCell
            else { return UICollectionViewCell() }
            
            cell.configure(item: item)
            return cell
        })
        
    }
    
    private func bind(reactor: LikeReactor) {
        reactor.state
            .map { $0.sections }
            .bind(to: cardCollectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(354))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

