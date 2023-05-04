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
import RxDataSources

class HPediaViewController: UIViewController, View {
    
    //MARK: - Properties
    lazy var hPediaCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: configureLayout()).then {
        $0.register(HPediaGuideHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HPediaGuideHeaderCell.identifier)
        $0.register(HPediaTagHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HPediaTagHeaderCell.identifier)
        $0.register(HPediaTagCell.self,
                    forCellWithReuseIdentifier: HPediaTagCell.identifier)
        $0.register(GuideCell.self,
                    forCellWithReuseIdentifier: GuideCell.identifier)
    }
    
    var datasource: RxCollectionViewSectionedReloadDataSource<HPediaSection>!
    var disposeBag = DisposeBag()
    lazy var reactor = HPediaReactor()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
        bind(reactor: reactor)
        
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        view.addSubview(hPediaCollectionView)
    }
    
    private func setConstraints() {
        hPediaCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.bottom.top.equalToSuperview()
        }
    }
    
    func bind(reactor: HPediaReactor) {
        reactor.state
            .map { $0.sections }
            .bind(to: hPediaCollectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
}

//MARK: - Functions
extension HPediaViewController {
    
    func configureDatasource () {
        datasource = RxCollectionViewSectionedReloadDataSource<HPediaSection>(configureCell: { _, collectionView, indexPath, item in
            switch item {
            case .tagCell(let reactor, _):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HPediaTagCell.identifier,
                    for: indexPath) as? HPediaTagCell
                else { return UICollectionViewCell() }
                
                cell.reactor = reactor
                
                return cell
                
            case .guideCell(let reactor, _):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GuideCell.identifier,
                    for: indexPath) as? GuideCell
                else { return UICollectionViewCell() }
                
                cell.reactor = reactor
                
                return cell
            }
        }, configureSupplementaryView: { _, collectionView, kind, indexPath -> UICollectionReusableView in 
            
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HPediaGuideHeaderCell.identifier,
                    for: indexPath) as? HPediaGuideHeaderCell
                else { return UICollectionReusableView() }
                
                return header
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader, 
                    withReuseIdentifier: HPediaTagHeaderCell.identifier,
                    for: indexPath) as? HPediaTagHeaderCell
                else { return UICollectionReusableView() }
                
                return header
            default: return UICollectionReusableView()
            }
        })
    }
    
    private func HPediaGuideCellLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                              heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                               heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                                , heightDimension: .absolute(16))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
   
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems  = [header]
        section.interGroupSpacing = 8
        section.contentInsets  = NSDirectionalEdgeInsets(top: 12,
                                                         leading: 0,
                                                         bottom: 56,
                                                         trailing: 0)
        return section
    }
    
    private func HPediaTagCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(64))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(64))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 0,
                                                      bottom: 0,
                                                      trailing: 16)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                                , heightDimension: .absolute(32))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets  = NSDirectionalEdgeInsets(top: 12,
                                                         leading: 0,
                                                         bottom: 0,
                                                         trailing: 0)
        return section
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.HPediaGuideCellLayout()
            default:
                return self.HPediaTagCellLayout()
            }
        }
    }
}
