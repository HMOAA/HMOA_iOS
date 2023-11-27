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
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(HPediaQnACell.self, forCellWithReuseIdentifier: HPediaQnACell.identifier)
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
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: MyLogWritedPostReactor) {
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { Reactor.Action.didSelectedCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.writedPostItems }
            .bind(to: collectionView.rx.items(cellIdentifier: HPediaQnACell.identifier, cellType: HPediaQnACell.self)) { row, item, cell in
                cell.isListCell = true
                cell.configure(item)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedId }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(onNext: presentQnADetailVC)
            .disposed(by: disposeBag)
        
        
    }
}

extension MyLogWritedPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 70)
    }
}