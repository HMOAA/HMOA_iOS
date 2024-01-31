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
import Hero


class HomeViewController: UIViewController, View {
    
    // MARK: ViewModel
    
    var homeReactor = HomeViewReactor()
    
    // MARK: Properties
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem>!
    var disposeBag = DisposeBag()
    
    private let loginManager = LoginManager.shared
    
    // MARK: - UI Component
    private lazy var homeView = HomeView()
    
//    private lazy var indicatorImageView = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.animationRepeatCount = 0
//        $0.animationDuration = 2
//        $0.animationImages = [
//            UIImage(named: "indicator1")!,
//            UIImage(named: "indicator2")!,
//            UIImage(named: "indicator3")!
//        ]
//    }
    
    private let bellButton = UIButton().then {
        $0.setImage(UIImage(named: "bellOn"), for: .selected)
        $0.setImage(UIImage(named: "bellOff"), for: .normal)
    }
    
    private lazy var bellBarButton = UIBarButtonItem(customView: bellButton).then {
        $0.customView?.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }
    
    private  var headerViewReactor: HomeHeaderReactor!
    
    //MARK: - Init
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setBrandSearchBellNaviBar("H  M  O  A", bellButton: bellBarButton)
        configureCollectionViewDataSource()
        bind(reactor: homeReactor)
    }
}

// MARK: - Functions
extension HomeViewController {
    
    // MARK: - Bind
    
    func bind(reactor: HomeViewReactor) {

        // MARK: - Action
        
        // viewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginManager.isPushAlarmAuthorization
            .map { Reactor.Action.settingAlarmAuthorization($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginManager.isUserSettingAlarm
            .map { Reactor.Action.settingIsUserSetting($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginManager.isLogin
            .map { Reactor.Action.settingIsLogin($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // collectionView item 클릭
        self.homeView.collectionView.rx.itemSelected
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        bellButton.rx.tap
            .map { Reactor.Action.didTapBellButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // snapshot 설정
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, sections in
                
                var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>()
                snapshot.appendSections(sections)
                        
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
    
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
                
            }).disposed(by: disposeBag)

        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedPerfumeId }
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, id in
                owner.presentDatailViewController(id)
            })
            .disposed(by: disposeBag)
        
        // 푸시 알람 권한, 유저 셋팅에 따른 ui 바인딩
        reactor.state
            .map { $0.isPushAlarm }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isPush in
                guard let isLogin = reactor.currentState.isLogin else { return }
                if isLogin {
                    owner.bellButton.isSelected = isPush
                } else { owner.bellButton.isSelected = false }
            })
            .disposed(by: disposeBag)
        
        // 벨 터치 이벤트
        reactor.state
            .map { $0.isTapBell }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                guard let isLogin = reactor.currentState.isLogin else { return }
                if isLogin {
                    // 앱 알람 권한 설정 이동
                    if reactor.currentState.isPushSettiong {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    // 유져 셋팅 알람 설정
                    if reactor.currentState.isPushAlarm ?? false {
                        DispatchQueue.main.async {
                            owner.loginManager.isUserSettingAlarm.onNext(false)
                            reactor.action.onNext(.deleteFcmToken)
                        }
                    } else {
                        DispatchQueue.main.async {
                            owner.loginManager.isUserSettingAlarm.onNext(true)
                            reactor.action.onNext(.postFcmToken)
                        }
                    }
                } else {
                    owner.presentAlertVC(
                        title: "로그인 후 이용가능한 서비스입니다",
                        content: "입력하신 내용을 다시 확인해주세요",
                        buttonTitle: "로그인 하러가기 ")
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindHeader(reactor: HomeHeaderReactor) {
        
        // MARK: - Action
        
        // MARK: - State
        
        reactor.state
            .map { $0.isPersentMoreVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentTotalPerfumeViewController)
            .disposed(by: disposeBag)
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem> (collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .topCell(let data, _):
                guard let homeTopCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeTopCell.identifier,
                    for: indexPath) as? HomeTopCell else {
                    return UICollectionViewCell()
                }
                
                homeTopCell.setImage(data)
                
                return homeTopCell
                
            case .recommendCell(let data, _):
                guard let firstCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeFirstCell.identifier,
                    for: indexPath) as? HomeFirstCell else {
                    return UICollectionViewCell()
                }
                
                guard let otherCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath) as? HomeCell else {
                    return UICollectionViewCell()
                }
                                
                if indexPath.section == 1 {
                    firstCell.bindUI(data, indexPath.row)
                    return firstCell
                } else {
                    otherCell.bindUI(data)
                    return otherCell
                }
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            var header = UICollectionReusableView()
            
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            else { return header }
            
            switch section {
            case .topSection(_):
                return header
                
            case .recommendSection(let title, _, let type):
                guard let homeCellHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCellHeaderView.identifier,
                    for: indexPath) as? HomeCellHeaderView else {
                    return UICollectionReusableView()
                }
                
                homeCellHeader.reactor = HomeHeaderReactor(title, type)
                self.bindHeader(reactor: homeCellHeader.reactor!)
                header = homeCellHeader
                
                return header
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        self.hero.isEnabled = true
        homeView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        [homeView] .forEach { view.addSubview($0) }

        homeView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        if indexPath.section == 1 && indexPath.row == 1 {
            if !homeReactor.currentState.isPaging {
                homeReactor.action.onNext(.scrollCollectionView)
            }
        }
    }
}
