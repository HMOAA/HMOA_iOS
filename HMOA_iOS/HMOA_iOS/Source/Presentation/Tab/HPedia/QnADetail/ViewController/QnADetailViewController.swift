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
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(QnAPostCell.self, forCellWithReuseIdentifier: QnAPostCell.identifier)
        
    }
    var disposeBag = DisposeBag()
    let reactor = QnADetailReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        configureDataSource()
        bind(reactor: reactor)
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
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: QnADetailReactor) {
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
    }
    
    func configureQnAPostSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(268))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(268))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(14)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureQnACommentSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(16)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        
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
