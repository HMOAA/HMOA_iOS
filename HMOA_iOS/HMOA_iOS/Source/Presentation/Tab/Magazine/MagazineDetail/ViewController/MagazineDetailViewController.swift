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
        $0.register(MagazineLikeCell.self, forCellWithReuseIdentifier: MagazineLikeCell.identifier)
        $0.register(MagazineLatestCell.self, forCellWithReuseIdentifier: MagazineLatestCell.identifier)
        
        $0.register(MagazineDetailHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineDetailHeaderView.identifier)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<MagazineDetailSection, MagazineDetailItem>?
    
    private var sections = [MagazineDetailSection]()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(magazineDetailCollectionView)
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: MagazineDetailReactor) {
        // MARK: - Action
        
        
        // MARK: - State
        reactor.state
            .map{ _ in "" }
            .observe(on: MainScheduler.instance)
            .bind(onNext: setBackShareRightNaviBar)
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
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .title:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case .content:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1500))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1500))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 36, leading: 0, bottom: 4, trailing: 0)
                
                return section
                
            case .like:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case .latestMagazine:
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SupplementaryViewKind.background)
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(132), heightDimension: .estimated(300))
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
            case .title:
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
                
            case .like:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineLikeCell.identifier, for: indexPath) as! MagazineLikeCell
                cell.configureCell(item.like!)
                
                return cell
                
            case .latestMagazine:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineLatestCell.identifier, for: indexPath) as! MagazineLatestCell
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
                case .latestMagazine:
                    sectionTitle = "최신 매거진"
                default:
                    return nil
                }
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineDetailHeaderView.identifier, for: indexPath) as! MagazineDetailHeaderView
                headerView.configureHeader(sectionTitle)
                
                return headerView
                
            default:
                return nil
            }
        }
        
        // MARK: Initial Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<MagazineDetailSection, MagazineDetailItem>()
        snapshot.appendSections([.title, .content, .like, .latestMagazine])
        
        // TODO: 선택한 매거진을 표시하도록 변경
        snapshot.appendItems([MagazineDetailItem.magazineInfo], toSection: .title)
        snapshot.appendItems(MagazineDetailItem.magazineContents, toSection: .content)
        snapshot.appendItems([MagazineDetailItem.magazineLike], toSection: .like)
        snapshot.appendItems(MagazineDetailItem.otherMagazines, toSection: .latestMagazine)
        
        sections = snapshot.sectionIdentifiers
        dataSource?.apply(snapshot)
    }
}
