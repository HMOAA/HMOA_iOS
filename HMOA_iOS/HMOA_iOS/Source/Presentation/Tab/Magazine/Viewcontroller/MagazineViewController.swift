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
    }
    
    private lazy var magazineCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineMainCell.self, forCellWithReuseIdentifier: MagazineMainCell.identifier)
        $0.register(MagazineNewPerfumeCell.self, forCellWithReuseIdentifier: MagazineNewPerfumeCell.identifier)
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
            let section = self.sections[sectionIndex]
            switch section {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 22, trailing: 0)
                
                let groupWidth = layoutEnvironment.container.effectiveContentSize.width
                let centerImageWidth = groupWidth * 0.92
                let centerImageHeight = centerImageWidth / 328 * 376
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(centerImageHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 8
                
                return section
                
            case .newPerfume:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(155), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 16, bottom: 20, trailing: 16)
                section.interGroupSpacing = 8
                
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
            }
        })
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<MagazineSection, MagazineItem>()
        snapshot.appendSections([.main, .newPerfume])
        snapshot.appendItems(MagazineItem.mainMagazines, toSection: .main)
        snapshot.appendItems(MagazineItem.newPerfumes, toSection: .newPerfume)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
