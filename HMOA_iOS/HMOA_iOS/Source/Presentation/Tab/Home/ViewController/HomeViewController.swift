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
    
    let viewModel = HomeViewModel()
    let homeReactor = HomeViewReactor()
    
    // MARK: Properties
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSection.Model>!
    var disposeBag = DisposeBag()

    lazy var homeView = HomeView()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureAction()
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
    }
    
    @objc func bellButtonClicked() {
    }
}

// MARK: - Functions
extension HomeViewController {
    
    func bind(reactor: HomeViewReactor) {

        // action
        homeReactor.action.onNext(HomeViewReactor.Action.viewDidLoad)
        
        self.homeView.collectionView.rx.itemSelected
            .do(onNext: {
                print($0)
            })
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // state
        reactor.state.map { [$0.homeTopSection, $0.homeFirstSection, $0.homeSecondSection, $0.homeWatchSection] }
            .distinctUntilChanged()
            .bind(to: self.homeView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isPresentDetailVC }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
    }
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection.Model>(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            
            switch indexPath.section {
            case 0:
                guard let homeTopCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeTopCell.identifier,
                    for: indexPath) as? HomeTopCell else {
                    return UICollectionViewCell()
                }
                switch item {
                case .photo(let photo):
                    homeTopCell.setImage(photo!)
                case .Info(_):
                    break
                }
                return homeTopCell
            case 3:
                guard let homeWatchCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeWatchCell.identifier,
                    for: indexPath) as? HomeWatchCell else {
                    return UICollectionViewCell()
                }
                
                switch item {
                case .photo(_):
                    break
                case .Info(let perfume):
                    homeWatchCell.setUI(item: perfume)
                }
                
                return homeWatchCell
            default:
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                
                switch item {
                case .photo(_):
                    break
                case .Info(let perfume):
                    homeCell.setUI(item: perfume)
                }
                
                return homeCell
            }
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: HomeTopCellFooterView.identifier,
                for: indexPath) as? HomeTopCellFooterView else {
                return UICollectionReusableView()
            }

            var header = UICollectionReusableView()
        
            switch indexPath.section {
            case 0:
                return footer
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
    
    func configureAction() {
        homeView.leftButton.addTarget(
            self,
            action: #selector(leftButtonClicked),
            for: .touchUpInside)
        
        homeView.rightButton.addTarget(
            self,
            action: #selector(rightButtonClicked),
            for: .touchUpInside)
    }
}
