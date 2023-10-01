//
//  QnADetailViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class QnADetailViewController: UIViewController, View {

    //MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<QnADetailSection, QnADetailSectionItem>!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        $0.register(QnAPostHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAPostHeaderView.identifier)
        $0.register(QnACommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnACommentHeaderView.identifier)
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(QnAPostCell.self, forCellWithReuseIdentifier: QnAPostCell.identifier)
        
    }
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        setNavigationBarTitle(title: "Community", color: .white, isHidden: false)
        configureDataSource()
    }

    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: QnADetailReactor) {
        
        // Action
        
        // viewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        
        //colectionView binding
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, sections in
                
                var snapshot = NSDiffableDataSourceSnapshot<QnADetailSection, QnADetailSectionItem>()
                snapshot.appendSections(sections)
                sections.forEach { section in
                    snapshot.appendItems(section.item, toSection: section)
                }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension QnADetailViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<QnADetailSection, QnADetailSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .qnaPostCell(let qnaPost):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QnAPostCell.identifier, for: indexPath) as? QnAPostCell else { return UICollectionViewCell() }
                
                cell.updateCell(qnaPost)
                return cell
            case .commentCell(let comment):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                cell.updateCell(comment)
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAPostHeaderView.identifier, for: indexPath) as? QnAPostHeaderView else { return UICollectionReusableView() }
                
                return header
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnACommentHeaderView.identifier, for: indexPath) as? QnACommentHeaderView else { return UICollectionReusableView() }
                
                return header
            }
        }
    }
    
    func configureQnAPostSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(268))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(268))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(14)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 46, leading: 16, bottom: 52, trailing: 16)
        sectionHeader.contentInsets = .init(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func configureQnACommentSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 0, bottom: 12, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                return self.configureQnAPostSection()
            default:
                return self.configureQnACommentSection()
            }
            
        }
    }
}
