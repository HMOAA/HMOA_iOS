//
//  MagazineViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit
import SnapKit
import RxCocoa
import ReactorKit
import RxSwift

class MagazineViewController: UIViewController, View {
    
    private lazy var magazineCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineMainCell.self, forCellWithReuseIdentifier: MagazineMainCell.identifier)
        $0.register(MagazineNewPerfumeCell.self, forCellWithReuseIdentifier: MagazineNewPerfumeCell.identifier)
        $0.register(MagazineTopReviewCell.self, forCellWithReuseIdentifier: MagazineTopReviewCell.identifier)
        $0.register(MagazineAllCell.self, forCellWithReuseIdentifier: MagazineAllCell.identifier)
        
        $0.register(MagazineHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineHeaderView.identifier)
    }
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<MagazineSection, MagazineItem>?
    
    private var sections = [MagazineSection]()
    
    private let currentPageSubject = PublishSubject<Int>()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddView()
        setUI()
        setConstraints()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    // MARK: - Bind
    
    func bind(reactor: MagazineReactor) {
        // MARK: Action
        
        // viewDidLoad
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // allMagazine 마지막 아이템이 나타나면 다음 페이지 로드
        magazineCollectionView.rx.willDisplayCell
            .filter { cellInfo in
                let sectionIndex = self.sections.firstIndex(of: .allMagazine)!
                let isLastItem = cellInfo.at.item == self.magazineCollectionView.numberOfItems(inSection: sectionIndex) - 1
                return cellInfo.at.section == sectionIndex && isLastItem
            }
            .map { _ in 
                print(reactor.currentState.currentMagazineListPage)
                return Reactor.Action.loadMagazineListNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // magazine item 터치
        magazineCollectionView.rx.itemSelected
            .filter { $0.section == 0 || $0.section == 3 }
            .map { Reactor.Action.didTapMagazineCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // new perfume item 터치
        magazineCollectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .map { Reactor.Action.didTapNewPerfuleCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // top review item 터치
        magazineCollectionView.rx.itemSelected
            .filter { $0.section == 2 }
            .map { Reactor.Action.didTapTopReviewCell($0) }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
        
        // MARK: State
        
        // MainBannerItems 변화 감지
        reactor.state
            .map { $0.mainBannerItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .mainBanner, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // NewPerfumeItems 변화 감지
        reactor.state
            .map { $0.newPerfumeItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .newPerfume, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // TopReviewItems 변화 감지
        reactor.state
            .map { $0.topReviewItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .topReview, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // AllMagazineItems 변화 감지
        reactor.state
            .map { $0.allMagazineItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .allMagazine, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // mainBanner center page 감지
        currentPageSubject
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { page in
                self.reactor?.action.onNext(.currentPageChanged(page))
            })
            .disposed(by: disposeBag)
            
        // center magazine의 이미지를 배경에 반영
        reactor.state
            .compactMap { $0.centeredMagazineImageURL}
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self) { owner, url in
                MagazineBannerImageURLManager.shared.imageURL = url
            }
            .disposed(by: disposeBag)
        
        // MagazineDetailVC로 push
        reactor.state
            .compactMap { $0.selectedMagazineID }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self) { owner, id in
                owner.presentMagazineDetailViewController(id)
            }
            .disposed(by: disposeBag)
        
        // DetailVC로 push
        reactor.state
            .compactMap { $0.selectedNewPerfumeID }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self) { owner, id in
                owner.presentDatailViewController(id)
            }
            .disposed(by: disposeBag)
        
        // CommunityDetailVC로 push
        reactor.state
            .compactMap { $0.selectedCommunityID }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self) { owner, id in
                owner.presentCommunityDetailVC(id)
            }
            .disposed(by: disposeBag)
    }
    
    private func setAddView() {
        view.addSubview(magazineCollectionView)
    }
    
    private func setUI() {
        magazineCollectionView.contentInsetAdjustmentBehavior = .never
        magazineCollectionView.backgroundColor = .clear
        view.backgroundColor = .white
    }
    
    private func setConstraints() {
        magazineCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
            let centerImageWidth = availableLayoutWidth * 0.92
            let centerImageHeight = centerImageWidth / 328 * 376
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .mainBanner:
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SupplementaryViewKind.magazineBackground)
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(centerImageHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 115, leading: 0, bottom: 22, trailing: 0)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 4
                section.decorationItems = [backgroundDecoration]
                section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in
                    let currentPage = Int(max(0, round(offset.x / env.container.contentSize.width)))
                    self.currentPageSubject.onNext(currentPage)
                    
                    let cellItems = visibleItems.filter {
                        $0.representedElementKind != SupplementaryViewKind.magazineBackground
                    }
                    cellItems.forEach { item in
                        let frame = item.frame
                        let rect = CGRect(
                            x: offset.x,
                            y: offset.y,
                            width: env.container.contentSize.width,
                            height: frame.height
                        )
                        let inter = rect.intersection(frame)
                        let percent: CGFloat = inter.width / frame.width
                        let scale = 0.95 + (0.05 * percent)
                        item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
                    }
                }
                
                return section
                
            case .newPerfume:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(155), heightDimension: .absolute(213))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
                
            case .topReview:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(296), heightDimension: .absolute(206))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
                
            case .allMagazine:
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(centerImageWidth * 1.4))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 56, trailing: 16)
                section.interGroupSpacing = 56
                
                return section
            }
        }
        
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: SupplementaryViewKind.magazineBackground)
        
        return layout
    }
    
    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: magazineCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .mainBanner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineMainCell.identifier, for: indexPath) as! MagazineMainCell
                cell.configureCell(item.magazine!)
                
                return cell
                
            case .newPerfume:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineNewPerfumeCell.identifier, for: indexPath) as! MagazineNewPerfumeCell
                cell.configureCell(item.newPerfume!)
                
                return cell
                
            case .topReview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineTopReviewCell.identifier, for: indexPath) as! MagazineTopReviewCell
                cell.configureCell(item.topReview!)
                
                return cell
                
            case .allMagazine:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineAllCell.identifier, for: indexPath) as! MagazineAllCell
                cell.configureCell(item.magazine!)
                
                return cell
            }
        })
        
        // MARK: Supplementary View Provider
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionTitle: String
                let sectionDescription: String
                switch section {
                case .newPerfume:
                    sectionTitle = "출시향수"
                    sectionDescription = "새롭게 출시된 향수를 확인해보세요."
                case .topReview:
                    sectionTitle = "TOP 10 시향기"
                    sectionDescription = "리뷰로 느껴보는 향수"
                case .allMagazine:
                    sectionTitle = "HMOA\nNEWS / 매거진"
                    sectionDescription = "향모아가 전하는 향수 트렌드 이슈"
                default:
                    return nil
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineHeaderView.identifier, for: indexPath) as! MagazineHeaderView
                headerView.configureHeader(sectionTitle, sectionDescription)
                
                return headerView
                
            default:
                return nil
            }
        }
        
        // MARK: Initial Snapshot
        var initialSnapshot = NSDiffableDataSourceSnapshot<MagazineSection, MagazineItem>()
        initialSnapshot.appendSections([.mainBanner, .newPerfume, .topReview, .allMagazine])

        sections = initialSnapshot.sectionIdentifiers
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: MagazineSection, withItems items: [MagazineItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


extension MagazineViewController {
    private func setNavigationBar() {
        title = "Magazine"
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .clear
        scrollEdgeAppearance.shadowColor = .clear
        scrollEdgeAppearance.backgroundEffect = nil
        scrollEdgeAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.pretendard, 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.pretendard, 20)
        ]
    }
}
