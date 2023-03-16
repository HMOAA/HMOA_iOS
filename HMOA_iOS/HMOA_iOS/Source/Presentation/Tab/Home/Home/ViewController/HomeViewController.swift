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

    // MARK: - UI Component
    lazy var homeView = HomeView()
    
    lazy var brandSearchButton = UIButton().makeImageButton(UIImage(named: "homeMenu")!)
    
    lazy var searchButton = UIButton().makeImageButton(UIImage(named: "search")!)
    
    lazy var bellButton = UIButton().makeImageButton(UIImage(named: "bell")!)
    
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureCollectionViewDataSource()
        bind(reactor: homeReactor)
    }
    
    // MARK: objc functions
    
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
        
        // 브랜드 검색 버튼 클릭
        brandSearchButton.rx.tap
            .map { Reactor.Action.didTapBrandSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 종합 검색 버튼 클릭
        searchButton.rx.tap
            .map { Reactor.Action.didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 알림 버튼 클릭
        bellButton.rx.tap
            .map { Reactor.Action.didTapBellButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // collectionView 바인딩
        reactor.state
            .map { $0.sections }
            .bind(to: self.homeView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)

        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
        
        // 브랜드 검색 페이지로 이동
        reactor.state
            .map { $0.isPresentBrandSearchVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: presentBrandSearchViewController)
            .disposed(by: disposeBag)
        
        // 종합 검색 화면으로 이동
        reactor.state
            .map { $0.isPresentSearchVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: presentSearchViewController)
            .disposed(by: disposeBag)
    }
    
    func bindHeader() {
        
        // MARK: - Action
        
        // MARK: - State
        
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
                guard let homeFirstCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeFirstCell.identifier,
                    for: indexPath) as? HomeFirstCell else {
                    return UICollectionViewCell()
                }
            
                homeFirstCell.reactor = reactor
                
                return homeFirstCell
            case .homeSecondCell(let reactor, _):
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                
                homeCell.reactor = reactor
                
                return homeCell
            case .homeThridCell(let reactor, _):
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                
                homeCell.reactor = reactor
                
                return homeCell
            case .homeFourthCell(let reactor, _):
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                
                homeCell.reactor = reactor
                
                return homeCell
            }
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

            var header = UICollectionReusableView()
            
            
            switch indexPath.section {
            case 1:
                guard let homeFirstCellHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeFirstCellHeaderView.identifier,
                    for: indexPath) as? HomeFirstCellHeaderView else {
                    return UICollectionReusableView()
                }
                
                homeFirstCellHeader.reactor = HomeHeaderReactor("향모아 사용자들이 좋아한")
                
                header = homeFirstCellHeader
                
            case 2:
                guard let homeCellheader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCellHeaderView.identifier,
                    for: indexPath) as? HomeCellHeaderView else {
                    return UICollectionReusableView()
                }
                homeCellheader.reactor = HomeHeaderReactor("이 제품 어떠세요? 향모아가 추천하는")
                
                header = homeCellheader
                
            case 3:
                guard let homeCellheader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCellHeaderView.identifier,
                    for: indexPath) as? HomeCellHeaderView else {
                    return UICollectionReusableView()
                }
                homeCellheader.reactor = HomeHeaderReactor("변함없이 사랑받는, 스테디 셀러")
                header = homeCellheader


            case 4:
                guard let homeCellheader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCellHeaderView.identifier,
                    for: indexPath) as? HomeCellHeaderView else {
                    return UICollectionReusableView()
                }
                
                homeCellheader.reactor = HomeHeaderReactor("최근 발매된")
                header = homeCellheader

            default: return header
                
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
                
        let bracnSearchButtonItem = UIBarButtonItem(customView: brandSearchButton)
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        let bellButtonItem = UIBarButtonItem(customView: bellButton)
        
        navigationItem.titleView = titleLabel
        
        navigationItem.leftBarButtonItems = [spacerItem(13), bracnSearchButtonItem]
        
        navigationItem.rightBarButtonItems = [bellButtonItem, spacerItem(15), searchButtonItem]
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
