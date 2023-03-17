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
    
    let cardLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 16
        $0.itemSize = CGSizeMake(280, 354)
        $0.scrollDirection = .horizontal
        
    }
    
    let reactor = LikeReactor()
    let disposeBag = DisposeBag()
    private var datasource: RxCollectionViewSectionedReloadDataSource<CardSection>!
    
    lazy var cardCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: cardLayout).then {
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
            make.leading.equalToSuperview().inset(40)
            make.trailing.equalToSuperview()
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
}
