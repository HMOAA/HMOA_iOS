//
//  CommunityListViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/08.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import QuartzCore
import RxGesture

class CommunityListViewController: UIViewController, View {

    //MARK: - UI Components
    private let searchBar = UISearchBar().configureHpediaSearchBar()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureInitCollectionLayout(false)).then {
        $0.register(CommunityListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommunityListHeaderView.identifier)
        $0.register(HPediaCommunityCell.self, forCellWithReuseIdentifier: HPediaCommunityCell.identifier)
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
    var disposeBag = DisposeBag()
    private var datasource: UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackItemNaviBar("Community")
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        // 현재 ViewController가 나갈 때 floatingView와 floatingButton을 제거
        floatingStackView.removeFromSuperview()
        floatingView.removeFromSuperview()
        floatingButton.removeFromSuperview()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    private func setAddView() {
        
        floatingButtons.forEach {
            floatingStackView.addArrangedSubview($0)
        }
        
        [
            searchBar,
            collectionView
        ]   .forEach { view.addSubview($0) }

    }

    private func setConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            
        }
    }
    
    // MARK: - Bind
    
    func bind(reactor: CommunityListReactor) {
        
        // MARK: - Action
        
        // WillDisplayCell
        collectionView.rx.willDisplayCell
            .map {
                let currentItem = $0.at.item
                if (currentItem + 1) % 10 == 0 && currentItem != 0 {
                    return currentItem / 10 + 1
                }
                return nil
            }
            .compactMap { $0 }
            .map { Reactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // ViewDidLoad
        LoginManager.shared.isLogin
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //viewWillAppear
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
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
        
        //콜렉션 뷰 아이템 터치
        collectionView.rx.itemSelected
            .map { Reactor.Action.didTapCommunityCell($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // searchBar text 변경
        searchBar.rx.text.orEmpty
            .map { Reactor.Action.didChangedSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // floatingView 터치
        floatingView.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.didTapFloatingBackView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // searchBar 검색 버튼 터치
            searchBar.rx.searchButtonClicked.map { _ in }
            .map { Reactor.Action.didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        //collectionView Binding
        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                guard let datasource = owner.datasource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<HPediaSection, HPediaSectionItem>()
                
                snapshot.appendSections([.community])
                
                items.forEach {
                    snapshot.appendItems([.community($0)], toSection: .community)
                }
                
                datasource.apply(snapshot, animatingDifferences: false)
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
        
        //선택된 카테고리 String CommunityWriteVC로 push
        reactor.state
            .compactMap { $0.selectedAddCategory }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.presentCommunityWriteVC(reactor)
            })
            .disposed(by: disposeBag)
        
        //선택된 셀 id CommunityDetailVC로 push
        reactor.state
            .map { $0.selectedPostId }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, id in
                owner.presentCommunityDetailVC(id, reactor)
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
        
        // header 숨기기
        reactor.state
            .map { $0.isSearch }
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isSearch in
                owner.collectionView.collectionViewLayout = owner.configureInitCollectionLayout(isSearch)
                
                // header 보이게 collectinoview 이동
                if !isSearch {
                    let newOffset = CGPoint(x: 0, y: 0)
                    owner.collectionView.setContentOffset(newOffset, animated: false)
                    // collectionview bottom이 키보드 레이아웃에 따를 경우 collectionview item 변경이 바로 적용 안 되고 드래그 해야 적용 돼 검색 상태에 따라 업데이트
                    owner.collectionView.snp.remakeConstraints { make in
                        make.leading.trailing.equalToSuperview()
                        make.top.equalTo(owner.searchBar.snp.bottom)
                        make.bottom.equalToSuperview()
                    }
                } else {
                    owner.collectionView.snp.remakeConstraints { make in
                        make.leading.trailing.equalToSuperview()
                        make.top.equalTo(owner.searchBar.snp.bottom)
                        make.bottom.equalTo(owner.view.keyboardLayoutGuide.snp.top)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // 검색 버튼 누를 시 키보드 숨기기
        reactor.state
            .map { $0.isHiddenKeyboard }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindHeader(_ header: CommunityListHeaderView) {
        // Action
        
        // 카테고리 버튼 터치
        Observable.merge(
            header.tagListView.tagViews[0].rx.tap.map { "추천" },
            header.tagListView.tagViews[1].rx.tap.map { "시향기" },
            header.tagListView.tagViews[2].rx.tap.map { "자유" })
        .map { Reactor.Action.didTapCategoryButton($0) }
        .bind(to: reactor!.action)
        .disposed(by: disposeBag)
    }
}

extension CommunityListViewController {
    
    private func configureInitCollectionLayout(_ isSearch: Bool) -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerHeight: CGFloat = isSearch ? 0 : 59
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = headerHeight > 0 ? [header] : []
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .community(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPediaCommunityCell.identifier, for: indexPath) as? HPediaCommunityCell else { return UICollectionViewCell() }
                cell.isListCell = true
                cell.configure(data)
                
                return cell
                
            default: return UICollectionViewCell()
            }
        })
        
        datasource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.item {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommunityListHeaderView.identifier, for: indexPath) as? CommunityListHeaderView else { return UICollectionReusableView() }
                self.bindHeader(header)
                return header
            default: return UICollectionReusableView()
            }
        }
    }
}
