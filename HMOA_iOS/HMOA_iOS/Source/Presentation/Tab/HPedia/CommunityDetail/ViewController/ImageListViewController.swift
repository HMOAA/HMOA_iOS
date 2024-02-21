//
//  ImageListViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/15/23.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import RxGesture
import Kingfisher


class ImageListViewController: UIViewController, View {

    
    // MARK: - UIComponents
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        $0.backgroundColor = .black
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    
    private let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    // MARK: - Properties
    
    private var datasource: UICollectionViewDiffableDataSource<PhotoSection, PhotoSectionItem>!
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        configureDatasource()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .black
    }
    
    private func setAddView() {
        [
            collectionView,
            xButton
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.width.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(xButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(80)
        }
    }
    
    // MARK: - Bind
    
    func bind(reactor: ImageListReactor) {
        
        // MARK: - Action
    
        // xButton 터치
        xButton.rx.tap
            .map { Reactor.Action.didTapXButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // collectionView 아래로 끌어당길 시
        collectionView.rx.contentOffset
            .map { $0.y }
            .filter { $0 < -100 }
            .map { _ in Reactor.Action.didScrollToTop }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // collectionView Binding
        reactor.state
            .map { $0.images }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, item in
                var snapshot = NSDiffableDataSourceSnapshot<PhotoSection, PhotoSectionItem>()
                
                snapshot.appendSections([.photo])
                item.forEach { snapshot.appendItems([.photoCell(nil, $0)]) }
                
                DispatchQueue.main.async {
                    owner.datasource.apply(snapshot)
                }
            }
            .disposed(by: disposeBag)
        
        // dismiss
        reactor.state
            .map { $0.isDismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 선택된 이미지로 scroll
        reactor.state
            .map { $0.selectedRow }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, row in
                owner.collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredHorizontally, animated: false)
            }
            .disposed(by: disposeBag)
        
    }

}

extension ImageListViewController {
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
   
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource<PhotoSection, PhotoSectionItem>(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, item in
            
            switch item {
            case .photoCell(_, let item):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
                    return UICollectionViewCell()
                }
                
                cell.imageView.kf.setImage(with: URL(string: item!.photoUrl))
                cell.isZoomEnabled = true
                
                cell.imageView.rx.tapGesture { gestureRecognizer, _ in
                    gestureRecognizer.numberOfTapsRequired = 2
                }
                .when(.recognized)
                .bind(onNext: { _ in
                    cell.handleDoubleTap()
                })
                .disposed(by: cell.disposeBag)
                return cell
            }
        })
    }
}
