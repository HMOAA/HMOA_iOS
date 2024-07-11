//
//  TotalPerfumeViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class TotalPerfumeViewController: UIViewController, View {
    typealias Reactor = TotalPerfumeReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<TotalPerfumeSection, TotalPerfumeSectionItem>?
    // MARK: - UI Component
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(BrandDetailCollectionViewCell.self, forCellWithReuseIdentifier: BrandDetailCollectionViewCell.identifier)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setBackItemNaviBar("전체보기")
    }
}

extension TotalPerfumeViewController {
    
    // MARK: - bind
    
    func bind(reactor: TotalPerfumeReactor) {
        configureDataSource()
        
        // MARK: - Action
        
        //collectionView - item 클릭
        collectionView.rx.itemSelected
            .map { indexPath in
                let item = self.dataSource?.itemIdentifier(for: indexPath)
                switch item {
                case .perfumeList(let perfume):
                    return perfume
                case .none:
                    return nil
                }
            }
            .compactMap { $0 }
            .map { Reactor.Action.didTapItem($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // collectionView 바인딩
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, sections in
                guard let datasource = owner.dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<TotalPerfumeSection, TotalPerfumeSectionItem>()
                
                snapshot.appendSections(sections)
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                datasource.apply(snapshot)
            }).disposed(by: disposeBag)
        
        // item 클릭 시 향수 상세 화면으로 이동
        reactor.state
            .map { $0.selectedItem }
            .distinctUntilChanged()
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner,  perfume in
                owner.presentDetailViewController(perfume.perfumeId)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Configure
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TotalPerfumeSection, TotalPerfumeSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .perfumeList(let perfume):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandDetailCollectionViewCell.identifier, for: indexPath) as? BrandDetailCollectionViewCell else { return UICollectionViewCell() }
                
                cell.bindRecommendUI(perfume)
                
                return cell
            }
        }
        )}
}

extension TotalPerfumeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 28) / 2
        let heigth = width + 82
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 10, bottom: 0, right: 10)
    }
}


