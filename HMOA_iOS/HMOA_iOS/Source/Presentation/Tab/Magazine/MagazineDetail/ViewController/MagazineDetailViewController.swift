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
//        case otherMagazine
    }
    
    // MARK: - Properties
    
    private lazy var magazineDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MagazineDetailCell.self, forCellWithReuseIdentifier: MagazineDetailCell.identifier)
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
            let section = self.sections[sectionIndex]
            switch section {
            case .magazineContent:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(90))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(90))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 36, leading: 0, bottom: 4, trailing: 0)
                
                return section
            }
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: magazineDetailCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .magazineContent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineDetailCell.identifier, for: indexPath) as! MagazineDetailCell
                cell.configureCell(item.magazine!)
                
                return cell
            }
        })
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<MagazineDetailSection, MagazineItem>()
        snapshot.appendSections([.magazineContent])
        
        // TODO: 선택한 매거진을 표시하도록 변경
        snapshot.appendItems([MagazineItem.magazines[0]], toSection: .magazineContent)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
