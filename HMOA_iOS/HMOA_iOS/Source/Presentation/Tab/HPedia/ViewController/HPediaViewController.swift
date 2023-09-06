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

class HPediaViewController: UIViewController, View {
    
    //MARK: - Properties
    lazy var hPediaCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: configureLayout()).then {
        $0.register(HPediaQnAHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaQnAHeaderView.identifier)
        $0.register(HPediaQnACell.self,
                    forCellWithReuseIdentifier: HPediaQnACell.identifier)
        $0.register(HPediaDictionaryCell.self,
                    forCellWithReuseIdentifier: HPediaDictionaryCell.identifier)
    }
    lazy var searchBar = UISearchBar().then {
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(), for: .search, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "향에 대해 궁금한 점을 검색해보세요"
    }
    
    
    private var datasource: UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>?
    var disposeBag = DisposeBag()
    let reactor = HPediaReactor()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
        configureSearchNavigationBar(nil, searchBar: searchBar)
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
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func bind(reactor: HPediaReactor) {
        
        reactor.state
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, state in
                guard let datasource = owner.datasource else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<HPediaSection, HPediaSectionItem>()
                snapshot.appendSections([.dictionary, .qna])
                
                state.DictionarySectionItems
                    .forEach { snapshot.appendItems([.dictionary($0)], toSection: .dictionary) }
                state.qnASectionItems
                    .forEach { snapshot.appendItems([.qna($0)], toSection: .qna) }
                
                DispatchQueue.main.async {
                    datasource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Functions
extension HPediaViewController {
    
    func configureDatasource () {
        datasource = UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>(collectionView: hPediaCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .qna(let data):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HPediaQnACell.identifier,
                    for: indexPath) as? HPediaQnACell
                else { return UICollectionViewCell() }
                
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
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaQnAHeaderView.identifier, for: indexPath) as? HPediaQnAHeaderView else { return UICollectionReusableView() }
                
                
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
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets  = NSDirectionalEdgeInsets(top: 33,
                                                         leading: 0,
                                                         bottom: 43,
                                                         trailing: 0)
        return section
    }
    
    private func HPediaQnACellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(68.64))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(68.64))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 0,
                                                      bottom: 0,
                                                      trailing: 16)

        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15.69, trailing: 16)
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
                return self.HPediaQnACellLayout()
            }
        }
    }
}
