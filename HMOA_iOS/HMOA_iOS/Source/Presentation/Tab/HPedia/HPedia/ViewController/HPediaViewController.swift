//
//  HPediaViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/09.
//

import UIKit

import Then
import TagListView
import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import RxAppState

class HPediaViewController: UIViewController, View {
    
    //MARK: - UIComponents
    private lazy var hPediaCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: configureLayout()).then {
        $0.register(HPediaCommunityHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaCommunityHeaderView.identifier)
        $0.register(HPediaCommunityCell.self,
                    forCellWithReuseIdentifier: HPediaCommunityCell.identifier)
        $0.register(HPediaDictionaryCell.self,
                    forCellWithReuseIdentifier: HPediaDictionaryCell.identifier)
    }
    private lazy var searchBar = UISearchBar().then {
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(), for: .search, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "향에 대해 궁금한 점을 검색해보세요"
    }
    
    private let floatingButton = UIButton().then {
        $0.setImage(UIImage(named: "addButton"), for: .normal)
        $0.setImage(UIImage(named: "selectedAddButton"), for: .selected)
    }
    
    private let recommendButton = UIButton().makeFloatingListButton(title: "추천")
    
    private let reviewButton = UIButton().makeFloatingListButton(title: "시향기")
    
    private let etcButton = UIButton().makeFloatingListButton(title: "자유")
    
    private lazy var floatingButtons = [recommendButton, reviewButton, etcButton]
    
    private let floatingStackView = UIStackView().then {
        $0.alpha = 0
        $0.backgroundColor = .black
        $0.isHidden = true
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 10
        $0.axis = .vertical
    }
    
    private lazy var floatingView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        $0.alpha = 0
        $0.isHidden = true
        
    }
    
    //MARK: - Properties
    private var datasource: UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>?
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            [
                floatingView,
                floatingButton,
                floatingStackView
            ]   .forEach { window.addSubview($0) }
            
            floatingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            floatingButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(12)
                make.bottom.equalToSuperview().offset(-95)
                make.width.height.equalTo(56)
            }
            
            floatingStackView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(8)
                make.width.equalTo(135)
                make.height.equalTo(137)
                make.bottom.equalTo(floatingButton.snp.top).offset(-8)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        floatingStackView.removeFromSuperview()
        floatingView.removeFromSuperview()
        floatingButton.removeFromSuperview()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        view.addSubview(hPediaCollectionView)
        
        floatingButtons.forEach {
            floatingStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        hPediaCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func bind(reactor: HPediaReactor) {
        // MARK: - Action
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // setIsLogin
        LoginManager.shared.isLogin
            .skip(1)
            .map { Reactor.Action.observeIsLogin($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // dictionary item 터치
        hPediaCollectionView.rx.itemSelected
            .filter { $0.section == 0 }
            .map { Reactor.Action.didTapDictionaryItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // ComunityItem 터치
        hPediaCollectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .map { Reactor.Action.didTapCommunityItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //floatinButton 터치
        floatingButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(350), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapFloatingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //추천 버튼 터치
        recommendButton.rx.tap
            .map { Reactor.Action.didTapRecommendButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //선물 버튼 터치
        reviewButton.rx.tap
            .map { Reactor.Action.didTapReviewButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //기타 버튼 터치
        etcButton.rx.tap
            .map { Reactor.Action.didTapEtcButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // floatingView 터치
        floatingView.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.didTapFloatingBackView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: - State
        
        // collectionView binding
        reactor.state
            .map { $0.communityItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
                guard let datasource = owner.datasource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<HPediaSection, HPediaSectionItem>()
                snapshot.appendSections([.dictionary, .community])
                reactor.currentState.DictionarySectionItems
                    .forEach { snapshot.appendItems([.dictionary($0)], toSection: .dictionary) }
                item.forEach { snapshot.appendItems([.community($0)], toSection: .community) }
                
                datasource.apply(snapshot)
            
            })
            .disposed(by: disposeBag)
        
        //선택된 카테고리 String CommunityWriteVC로 push
        reactor.state
            .compactMap { $0.selectedAddCategory }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentCommunityWriteVC(reactor)
            })
            .disposed(by: disposeBag)
        
        //DictionaryVC로 선택된 Id push
        reactor.state
            .map { $0.selectedHPedia }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, type in
                owner.presentDictionaryViewController(type)
            })
            .disposed(by: disposeBag)
        
        // Community DetailVC로 push
        reactor.state
            .map { $0.selectedCommunityId }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentCommunityDetailVC(reactor: owner.reactor!)
            })
            .disposed(by: disposeBag)
        
        //플로팅 뷰, 다른 버튼들 애니메이션 보여주기
        reactor.state
            .map { $0.isFloatingButtonTap }
            .skip(1)
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isTap in
                owner.showFloatingButtonAnimation(
                    floatingButton: owner.floatingButton,
                    stackView: owner.floatingStackView,
                    backgroundView: owner.floatingView,
                    isTap: isTap)
            })
            .disposed(by: disposeBag)
        
        // 로그인 안되있을 시 present
        reactor.state
            .map { $0.isTapWhenNotLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentAlertVC(
                    title: "로그인 후 이용가능한 서비스입니다",
                    content: "입력하신 내용을 다시 확인해주세요",
                    buttonTitle: "로그인 하러가기 ")
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - CollectionView Configure
extension HPediaViewController {
    
    private func configureDatasource () {
        datasource = UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>(collectionView: hPediaCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .community(let data):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HPediaCommunityCell.identifier,
                    for: indexPath) as? HPediaCommunityCell
                else { return UICollectionViewCell() }
                
                cell.isListCell = false
                cell.configure(data)
    
                return cell
                
            case .dictionary(let data):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HPediaDictionaryCell.identifier,
                    for: indexPath) as? HPediaDictionaryCell
                else { return UICollectionViewCell() }
                
                cell.configure(data)
                
                return cell
            }
        })
        
        datasource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaCommunityHeaderView.identifier, for: indexPath) as? HPediaCommunityHeaderView else { return UICollectionReusableView() }
                
                header.titleLabel.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                
                header.titleLabel.text = "HPedia"
                header.allButton.isHidden = true
                
                return header
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaCommunityHeaderView.identifier, for: indexPath) as? HPediaCommunityHeaderView else { return UICollectionReusableView() }
                
                header.allButton.rx.tap
                    .asDriver(onErrorRecover: { _ in .empty() })
                    .drive(with: self, onNext: { owner, _ in
                        owner.presentCommunityListVC(owner.reactor!)
                    })
                    .disposed(by: header.disposeBag)
                
                return header
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    private func HPediaHPediaDictionaryCellLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                              heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                               heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
   
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets  = NSDirectionalEdgeInsets(top: 27,
                                                         leading: 0,
                                                         bottom: 19,
                                                         trailing: 0)
        return section
    }
    
    private func HPediaCommunityCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 0,
                                                      bottom: 0,
                                                      trailing: 16)

        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(38))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = 8
        
        return section
    }
    
    
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.HPediaHPediaDictionaryCellLayout()
            default:
                return self.HPediaCommunityCellLayout()
            }
        }
    }
}

extension HPediaViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}
