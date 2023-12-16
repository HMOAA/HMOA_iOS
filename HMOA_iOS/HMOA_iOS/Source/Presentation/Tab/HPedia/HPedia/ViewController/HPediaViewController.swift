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
import RxAppState

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
    
    //MARK: - Properties
    private var datasource: UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>!
    var disposeBag = DisposeBag()
    let reactor = HPediaReactor()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
        bind(reactor: reactor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
        // Action
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // dictionary item 터치
        hPediaCollectionView.rx.itemSelected
            .filter { $0.section == 0 }
            .map { Reactor.Action.didTapDictionaryItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // ComunityItem 터치
        hPediaCollectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .map { Reactor.Action.didTapCommunityItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        // collectionView binding
        reactor.state
            .map { $0.communityItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
                
                var snapshot = NSDiffableDataSourceSnapshot<HPediaSection, HPediaSectionItem>()
                snapshot.appendSections([.dictionary, .qna])
                
                reactor.currentState.DictionarySectionItems
                    .forEach { snapshot.appendItems([.dictionary($0)], toSection: .dictionary) }
                item.forEach { snapshot.appendItems([.qna($0)], toSection: .qna) }
                
                DispatchQueue.main.async {
                    owner.datasource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
        
        //DictionaryVC로 선택된 Id push
        reactor.state
            .map { $0.selectedHPedia }
            .compactMap { $0 }
            .bind(with: self) { owner, type in
                owner.presentDictionaryViewController(type)
            }
            .disposed(by: disposeBag)
        
        // Community DetailVC로 id Push
        reactor.state
            .map { $0.selectedCommunityId }
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, id in
                owner.presentQnADetailVC(id)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - CollectionView Configure
extension HPediaViewController {
    
    func configureDatasource () {
        datasource = UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>(collectionView: hPediaCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .qna(let data):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HPediaQnACell.identifier,
                    for: indexPath) as? HPediaQnACell
                else { return UICollectionViewCell() }
                
                cell.isListCell = false
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
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaQnAHeaderView.identifier, for: indexPath) as? HPediaQnAHeaderView else { return UICollectionReusableView() }
                
                header.titleLabel.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                
                header.titleLabel.text = "HPedia"
                header.allButton.isHidden = true
                
                return header
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPediaQnAHeaderView.identifier, for: indexPath) as? HPediaQnAHeaderView else { return UICollectionReusableView() }
                
                header.allButton.rx.tap
                    .bind(onNext: self.presentQnAListVC)
                    .disposed(by: header.disposeBag)
                
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
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets  = NSDirectionalEdgeInsets(top: 27,
                                                         leading: 0,
                                                         bottom: 19,
                                                         trailing: 0)
        return section
    }
    
    private func HPediaQnACellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: 0,
                                                      bottom: 0,
                                                      trailing: 16)

        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(38))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16)
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
