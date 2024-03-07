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

class MagazineDetailViewController: UIViewController {
    
    enum MagazineDetailSection: Hashable {
        case magazineContent
        case latestMagazine
    }
    
    enum SupplementaryViewKind {
        static let header = "magazineDetailHeader"
        static let background = "magazineDetailBackground"
    }
    
    // MARK: - Properties
    
    private lazy var magazineDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineDetailCell.self, forCellWithReuseIdentifier: MagazineDetailCell.identifier)
        $0.register(MagazineLatestCell.self, forCellWithReuseIdentifier: MagazineLatestCell.identifier)
        
        $0.register(MagazineDetailHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: MagazineDetailHeaderView.identifier)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<MagazineDetailSection, MagazineItem>!
    
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
        
    }
    
    // MARK: - Configure Layout
    
    private func setConstraints() {
        magazineDetailCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .magazineContent:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1500))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1500))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 36, leading: 0, bottom: 4, trailing: 0)
                
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
            case .magazineContent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineDetailCell.identifier, for: indexPath) as! MagazineDetailCell
                cell.configureCell(item.magazine!)
                
                return cell
                
            case .latestMagazine:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineLatestCell.identifier, for: indexPath) as! MagazineLatestCell
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
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<MagazineDetailSection, MagazineItem>()
        snapshot.appendSections([.magazineContent, .latestMagazine])
        
        // TODO: 선택한 매거진을 표시하도록 변경
        snapshot.appendItems([MagazineItem.magazines[0]], toSection: .magazineContent)
        snapshot.appendItems(MagazineItem.mainMagazines, toSection: .latestMagazine)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
