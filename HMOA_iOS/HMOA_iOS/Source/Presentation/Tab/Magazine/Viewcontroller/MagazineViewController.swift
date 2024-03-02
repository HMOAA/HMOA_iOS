//
//  MagazineViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

import RxCocoa
import ReactorKit
import UIKit

class MagazineViewController: UIViewController, View {

    enum MagazineSection: Hashable {
        case main
        case newPerfume
        case topReview
        case allMagazine
    }
    
    enum SupplementaryViewKind {
        static let header = "magazineHeader"
    }
    
    private lazy var magazineCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineMainCell.self, forCellWithReuseIdentifier: MagazineMainCell.identifier)
        $0.register(MagazineNewPerfumeCell.self, forCellWithReuseIdentifier: MagazineNewPerfumeCell.identifier)
        $0.register(MagazineTopReviewCell.self, forCellWithReuseIdentifier: MagazineTopReviewCell.identifier)
        $0.register(MagazineAllCell.self, forCellWithReuseIdentifier: MagazineAllCell.identifier)
        
        $0.register(MagazineHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineHeaderView.identifier)
    }
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<MagazineSection, MagazineItem>!
    
    var sections = [MagazineSection]()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(magazineCollectionView)
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: MagazineReactor) {
        
    }
    
    private func setConstraints() {
        magazineCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
            let centerImageWidth = availableLayoutWidth * 0.92
            let centerImageHeight = centerImageWidth / 328 * 376
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(centerImageHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(centerImageHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 54, trailing: 0)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 8
                
                return section
                
            case .newPerfume:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(219))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(155), heightDimension: .estimated(219))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 52, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
                
            case .topReview:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(193))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(296), heightDimension: .estimated(193))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 52, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
                
            case .allMagazine:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(466))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(466))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 52, trailing: 16)
                section.interGroupSpacing = 56
                
                return section
            }
        }
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: magazineCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .main:
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
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
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
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<MagazineSection, MagazineItem>()
        snapshot.appendSections([.main, .newPerfume, .topReview, .allMagazine])
        snapshot.appendItems(MagazineItem.mainMagazines, toSection: .main)
        snapshot.appendItems(MagazineItem.newPerfumes, toSection: .newPerfume)
        snapshot.appendItems(MagazineItem.top10Reviews, toSection: .topReview)
        snapshot.appendItems(MagazineItem.magazines, toSection: .allMagazine)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
