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


class HomeViewController: UIViewController, View {
    
    
    
    // MARK: - UI Component
    private lazy var homeView = HomeView()
    
    private let bellButton = UIButton().then {
        $0.setImage(UIImage(named: "homeBell"), for: .normal)
    }
    
    private lazy var bellBarButton = UIBarButtonItem(customView: bellButton).then {
        $0.customView?.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }
    
    //    lazy var indicatorImageView = UIImageView().then {
    //        $0.contentMode = .scaleAspectFit
    //        $0.animationRepeatCount = 0
    //        $0.animationDuration = 0.3
    //        $0.animationImages = [
    //            UIImage(named: "indicator1")!,
    //            UIImage(named: "indicator2")!,
    //            UIImage(named: "indicator3")!
    //        ]
    //    }
    
    // MARK: Properties
    private var datasource: UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem>?
    var disposeBag = DisposeBag()
    private var headerViewReactor: HomeHeaderReactor?
    private let loginManager = LoginManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presentHBTIOrderSheetViewController()
        configureUI()
        setSearchBellNaviBar("H  M  O  A", bellButton: bellBarButton)
        configureCollectionViewDataSource()
        navigationController?.delegate = self
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        homeView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        [homeView] .forEach { view.addSubview($0) }
        
        homeView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
//        indicatorImageView.snp.makeConstraints { make in
//            make.centerY.centerX.equalToSuperview()
//            make.width.height.equalTo(110)
//        }
//        
//        indicatorImageView.startAnimating()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HomeViewReactor) {
        
        // MARK: - Action
        
        // viewDidLoad
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
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
        
        // 벨 버튼 터치
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
                //owner.indicatorImageView.stopAnimating()
                var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>()
                snapshot.appendSections(sections)
                
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                guard let datasource = owner.datasource else { return }
                datasource.apply(snapshot)
            }).disposed(by: disposeBag)
        
        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.selectedPerfumeId }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, id in
                owner.presentDetailViewController(id)
            })
            .disposed(by: disposeBag)
        
        // 푸시알림 리스트로 push
        reactor.state
            .map { $0.isTapBell }
            .compactMap { $0 }
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isTap in
                owner.presentPushAlarmViewController()
            })
            .disposed(by: disposeBag)
        
        // 로그아웃일 때 알림리스트 보기 제한
        reactor.state
            .map { $0.isTapWhenNotLogin }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentAlertVC(
                    title: "로그인 후 이용가능한 서비스입니다",
                    content: "입력하신 내용을 다시 확인해주세요",
                    buttonTitle: "로그인 하러가기"
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHeader(reactor: HomeHeaderReactor) {
        
        // 전체보기 페이지 이동
        reactor.state
            .map { $0.isPersentMoreVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: presentTotalPerfumeViewController)
            .disposed(by: disposeBag)
    }
}

// MARK: - Datasource

extension HomeViewController {
    
    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem> (collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, item in
            
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
        
        datasource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            var header = UICollectionReusableView()
            
            guard let section = self.datasource?.snapshot().sectionIdentifiers[indexPath.section]
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
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        if indexPath.section == 1 && indexPath.row == 1 {
            if !(reactor?.currentState.isPaging)! {
                reactor?.action.onNext(.scrollCollectionView)
            }
        }
    }
}

// MARK: - Navigation Delegate

extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if shouldUseCustomAnimation(forOperation: operation, fromVC: fromVC, toVC: toVC) {
            let animationController = CustomNavigationAnimation()
            animationController.pushing = (operation == .push)
            
            return animationController
        } else {
            // nil을 반환하면 기본 애니메이션 사용
            return nil
        }
    }
    
    private func shouldUseCustomAnimation(forOperation operation: UINavigationController.Operation, fromVC: UIViewController, toVC: UIViewController) -> Bool {
        // Push 동작: HomeViewController에서 BrandSearchViewController로 이동
        if operation == .push && fromVC is HomeViewController && toVC is BrandSearchViewController {
            return true
        }
        // Pop 동작: BrandSearchViewController에서 HomeViewController로 돌아감
        else if operation == .pop && fromVC is BrandSearchViewController && toVC is HomeViewController {
            return true
        }
        return false
    }

}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}
