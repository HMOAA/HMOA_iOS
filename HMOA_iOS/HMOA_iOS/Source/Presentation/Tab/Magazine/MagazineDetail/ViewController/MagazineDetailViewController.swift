//
//  MagazineDetailViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/3/24.
//

import UIKit
import RxCocoa
import ReactorKit
import SnapKit

class MagazineDetailViewController: UIViewController, View {
    
    // MARK: - Properties
    
    private lazy var magazineDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineInfoCell.self, forCellWithReuseIdentifier: MagazineInfoCell.identifier)
        $0.register(MagazineContentsHeaderCell.self, forCellWithReuseIdentifier: MagazineContentsHeaderCell.identifier)
        $0.register(MagazineContentCell.self, forCellWithReuseIdentifier: MagazineContentCell.identifier)
        $0.register(MagazineContentsImageCell.self, forCellWithReuseIdentifier: MagazineContentsImageCell.identifier)
        $0.register(MagazineTagCell.self, forCellWithReuseIdentifier: MagazineTagCell.identifier)
        $0.register(MagazineLikeCell.self, forCellWithReuseIdentifier: MagazineLikeCell.identifier)
        $0.register(MagazineListCell.self, forCellWithReuseIdentifier: MagazineListCell.identifier)
        
        $0.register(MagazineDetailHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineDetailHeaderView.identifier)
        $0.register(MagazineDetailLineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: MagazineDetailLineView.identifier)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<MagazineDetailSection, MagazineDetailItem>?
    
    private var sections = [MagazineDetailSection]()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(magazineDetailCollectionView)
        setBackShareRightNaviBar("")
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: MagazineDetailReactor) {
        // MARK: - Action
        
        // viewDidLoad
        LoginManager.shared.isLogin
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // infoItem 변화 감지
        reactor.state
            .map { $0.infoItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                self.updateSnapshot(forSection: .info, withItems: items)
                
            })
            .disposed(by: disposeBag)
        
        // contentItems 변화 감지
        reactor.state
            .map { $0.contentItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                self.updateSnapshot(forSection: .content, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // likeItems 변화 감지
        reactor.state
            .map { $0.likeItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                self.updateSnapshot(forSection: .like, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // TagItems 변화 감지
        reactor.state
            .map { $0.tagItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                self.updateSnapshot(forSection: .tags, withItems: items)
            })
            .disposed(by: disposeBag)
        
        // otherMagazineItems 변화 감지
        reactor.state
            .map { $0.otherMagazineItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                self.updateSnapshot(forSection: .magazineList, withItems: items)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure Layout
    
    private func setConstraints() {
        magazineDetailCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // header 보조 뷰
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            // bottomLine 보조 뷰
            let lineItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
            let bottomLineItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: SupplementaryViewKind.bottomLine, alignment: .bottom)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .info:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 36, leading: 0, bottom: 43, trailing: 0)
                section.boundarySupplementaryItems = [bottomLineItem]
                
                return section
                
            case .content:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 43, leading: 16, bottom: 48, trailing: 16)
                section.interGroupSpacing = 20
                
                return section
                
            case .tags:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(28))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(28))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 43, trailing: 16)
                section.boundarySupplementaryItems = [bottomLineItem]
                
                return section
                
            case .like:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 36)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 60, leading: 16, bottom: 54, trailing: 16)
                section.boundarySupplementaryItems = [bottomLineItem]
                
                return section
                
            case .magazineList:
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SupplementaryViewKind.background)
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(132), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.decorationItems = [backgroundDecoration]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 50, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
            }
        }
        
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: SupplementaryViewKind.background)
        
        return layout
    }
    
    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: magazineDetailCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .info:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineInfoCell.identifier, for: indexPath) as! MagazineInfoCell
                cell.configureCell(item.info!)
                
                return cell
                
            case .content:
                guard let type = item.contents?.type else { return nil }
                
                switch type {
                case "header":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineContentsHeaderCell.identifier, for: indexPath) as! MagazineContentsHeaderCell
                    cell.configureCell(item.contents!)
                    
                    return cell
                    
                case "content":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineContentCell.identifier, for: indexPath) as! MagazineContentCell
                    cell.configureCell(item.contents!)
                    
                    return cell
                    
                case "image":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineContentsImageCell.identifier, for: indexPath) as! MagazineContentsImageCell
                    cell.configureCell(item.contents!)
                    
                    return cell
                    
                default:
                    return nil
                }
                
            case .tags:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineTagCell.identifier, for: indexPath) as! MagazineTagCell
                cell.configureCell(item.tag!)
                
                return cell
                
            case .like:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineLikeCell.identifier, for: indexPath) as! MagazineLikeCell
                
                cell.likeButton.rx.tap
                    .map { Reactor.Action.didTapLikeButton }
                    .bind(to: self.reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                self.reactor?.state
                    .map { $0.isTapWhenNotLogin }
                    .distinctUntilChanged()
                    .filter { $0 }
                    .bind(with: self, onNext: { owner, _ in
                        owner.presentAlertVC(
                            title: "로그인 후 이용가능한 서비스입니다",
                            content: "입력하신 내용을 다시 확인해주세요",
                            buttonTitle: "로그인 하러가기"
                        )
                    })
                    .disposed(by: cell.disposeBag)
                
                self.reactor?.state
                    .map { $0.isLiked }
                    .asDriver(onErrorRecover: { _ in .empty() })
                    .drive(with: self, onNext: { owner, isLiked in
                        cell.likeButton.isSelected = isLiked
                        cell.likeCountLabel.textColor = isLiked ? .black : UIColor.customColor(.gray2)
                    })
                    .disposed(by: cell.disposeBag)
                
                self.reactor?.state
                    .map { $0.likeCount }
                    .compactMap { $0 }
                    .asDriver(onErrorRecover: { _ in .empty() })
                    .drive(with: self, onNext: { owner, count in
                        cell.likeCountLabel.text = String(count)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.configureCell(item.like!)
                
                return cell
                
            case .magazineList:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineListCell.identifier, for: indexPath) as! MagazineListCell
                cell.configureCell(item.magazineRecommend!)
                
                return cell
            }
        })
        
        // MARK: Supplementary View Provider
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionTitle: String
                switch section {
                case .magazineList:
                    sectionTitle = "최신 매거진"
                default:
                    return nil
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineDetailHeaderView.identifier, for: indexPath) as! MagazineDetailHeaderView
                headerView.configureHeader(sectionTitle)
                
                return headerView
                
            case SupplementaryViewKind.bottomLine:
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: MagazineDetailLineView.identifier, for: indexPath) as! MagazineDetailLineView
                lineView.setColor(.customColor(.gray2))
                
                return lineView
                
            default:
                return nil
            }
        }
        
        // MARK: Initial Snapshot
        var initialSnapshot = NSDiffableDataSourceSnapshot<MagazineDetailSection, MagazineDetailItem>()
        initialSnapshot.appendSections([.info, .content, .tags, .like, .magazineList])
        
        // TODO: 선택한 매거진을 표시하도록 변경
//        initialSnapshot.appendItems([MagazineDetailItem.magazineInfo], toSection: .title)
//        initialSnapshot.appendItems(MagazineDetailItem.magazineContents, toSection: .content)
//        initialSnapshot.appendItems(MagazineDetailItem.magazineTags, toSection: .tags)
//        initialSnapshot.appendItems([MagazineDetailItem.magazineLike], toSection: .like)
//        initialSnapshot.appendItems(MagazineDetailItem.otherMagazines, toSection: .magazineList)
        
        sections = initialSnapshot.sectionIdentifiers
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: MagazineDetailSection, withItems items: [MagazineDetailItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
