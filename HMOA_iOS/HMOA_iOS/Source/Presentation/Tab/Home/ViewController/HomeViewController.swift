//
//  HomeViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

class HomeViewController: UIViewController, View {
    
    // MARK: ViewModel
    
    let homeReactor = HomeViewReactor()
    
    // MARK: Properties
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSection>!
    var disposeBag = DisposeBag()

    lazy var homeView = HomeView()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureCollectionViewDataSource()
        bind(reactor: homeReactor)
    }
    
    // MARK: objc functions
    
    @objc func leftButtonClicked() {
    }
    
    @objc func rightButtonClicked() {
    }
    
    @objc func menuButtonClicked() {
    }
    
    @objc func searchButtonClicked() {
        presentSearchViewController()
    }
    
    @objc func bellButtonClicked() {
    }
}

// MARK: - Functions
extension HomeViewController {
    
    // MARK: - Bind
    
    func bind(reactor: HomeViewReactor) {

        // MARK: - Action
        
        // collectionView item 클릭
        self.homeView.collectionView.rx.itemSelected
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        
        // collectionView 바인딩
        reactor.state.map { $0.sections }
            .bind(to: self.homeView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)

        // 향수 디테일 페이지로 이동
        reactor.state.map { $0.selectedPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
    }
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            
            switch item {
            case .homeTopCell(let image, _):
                guard let homeTopCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeTopCell.identifier,
                    for: indexPath) as? HomeTopCell else {
                    return UICollectionViewCell()
                }
                
                homeTopCell.setImage(image!)
                
                return homeTopCell
            case .homeFirstCell(let reactor, _):
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                
                homeCell.reactor = reactor
                
                return homeCell
            case .homeSecondCell(let reactor, _):
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                
                homeCell.reactor = reactor
                
                return homeCell
            case .homeWatchCell(let reactor, _):
                guard let homeWatchCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeWatchCell.identifier,
                    for: indexPath) as? HomeWatchCell else {
                    return UICollectionViewCell()
                }
            
                homeWatchCell.reactor = reactor
                
                return homeWatchCell
            }
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

            var header = UICollectionReusableView()
        
            switch indexPath.section {
            case 3:
                guard let homeWatchCellHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeWatchCellHeaderView.identifier,
                    for: indexPath) as? HomeWatchCellHeaderView else {
                    return UICollectionReusableView()
                }
                header = homeWatchCellHeader
            default:
                guard let homeCellheader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCellHeaderView.identifier,
                    for: indexPath) as? HomeCellHeaderView else {
                    return UICollectionReusableView()
                }
                header = homeCellheader
            }
            
            return header
        })
    }
    
    func configureNavigationBar() {
        
        setNavigationColor()
        
        let titleLabel = UILabel().then {
            $0.text = "H  M  O  A"
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let menuButton = navigationItem.makeButtonItem(self, action: #selector(menuButtonClicked), imageName: "homeMenu")
                
        let bellButton = navigationItem.makeButtonItem(self, action: #selector(bellButtonClicked), imageName: "bell")
        
        let searchButton = navigationItem.makeButtonItem(self, action: #selector(searchButtonClicked), imageName: "search")
        
        navigationItem.titleView = titleLabel
        
        navigationItem.leftBarButtonItems = [spacerItem(13), menuButton]
        
        navigationItem.rightBarButtonItems = [bellButton, spacerItem(15), searchButton]
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.white
        
        [homeView] .forEach { view.addSubview($0) }

        homeView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
    }
}
