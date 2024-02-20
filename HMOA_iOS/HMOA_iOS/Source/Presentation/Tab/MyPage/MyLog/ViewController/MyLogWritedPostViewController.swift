//
//  MyLogWritedPostViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/25/23.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class MyLogWritedPostViewController: UIViewController, View {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    
    // MARK: - UIComponents
    
    private let layout = UICollectionViewFlowLayout()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(HPediaCommunityCell.self, forCellWithReuseIdentifier: HPediaCommunityCell.identifier)
    }
    
    private lazy var noWriteView = NoLoginEmptyView(title:
                                                """
                                                작성한 게시글이
                                                없습니다
                                                """,
                                             subTitle:
                                                """
                                                커뮤니티에서 게시글을 작성 해주세요
                                                """,
                                            buttonHidden:  true).then {
        $0.isHidden = true
    }
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setAddView()
        setConstraints()
        setBackItemNaviBar("작성한 게시글")
    }
    
    // MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        view.addSubview(noWriteView)
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noWriteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    func bind(reactor: MyLogWritedPostReactor) {
        
        // MARK: - Action
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .map {
                let currentItem = $0.at.item
                if (currentItem + 1) % 10 == 0 && currentItem != 0 {
                    return currentItem / 10 + 1
                }
                return nil
            }
            .compactMap { $0 }
            .map { Reactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { Reactor.Action.didSelectedCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: - State
        
        reactor.state
            .map { $0.writedPostItems }
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: HPediaCommunityCell.identifier, cellType: HPediaCommunityCell.self)) { row, item, cell in
                cell.isListCell = true
                cell.configure(item)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.writedPostItems.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEmpty in
                if isEmpty {
                    owner.noWriteView.isHidden = false
                    owner.collectionView.isHidden = true
                } else {
                    owner.noWriteView.isHidden = true
                    owner.collectionView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedId }
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: presentCommunityDetailVC)
            .disposed(by: disposeBag)
        
        
    }
}

extension MyLogWritedPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 70)
    }
}
