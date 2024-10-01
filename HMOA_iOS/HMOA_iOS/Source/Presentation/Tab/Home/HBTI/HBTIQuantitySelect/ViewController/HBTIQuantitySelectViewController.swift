//
//  HBTIQuantitySelectViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

final class HBTIQuantitySelectViewController: UIViewController, View {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let hbtiQuantityTopView = HBTIQuantitySelectTopView()
    
    private lazy var hbtiQuantityTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(HBTIQuantitySelectCell.self, forCellReuseIdentifier: HBTIQuantitySelectCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    private let nextButton: UIButton = UIButton().makeInvalidHBTINextButton()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIQuantitySelectReactor) {
        
        // MARK: Action
        
        nextButton.rx.tap
            .map { HBTIQuantitySelectReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        reactor.state
            .compactMap { $0.selectedIndex }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, selectedIndex in
                for cell in owner.hbtiQuantityTableView.visibleCells {
                    guard let indexPath = owner.hbtiQuantityTableView.indexPath(for: cell),
                          let hbtiQuantityCell = cell as? HBTIQuantitySelectCell else { continue }
                    
                    hbtiQuantityCell.quantityButton.isSelected = indexPath.row == selectedIndex
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnabledNextButton }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
                owner.nextButton.backgroundColor = isEnabled ? .black : .customColor(.gray3)
            })
            .disposed(by: disposeBag)
                
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                guard let selectedIndex = owner.reactor?.currentState.selectedIndex else { return }
                guard let isFreeSelection = owner.reactor?.currentState.isFreeSelection else { return }
                let selectedQuantity = NotesQuantity.quantities[selectedIndex].quantity
                
                owner.presentHBTINotesCategoryViewController(selectedQuantity, isFreeSelection)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         hbtiQuantityTopView,
         hbtiQuantityTableView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        hbtiQuantityTopView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        hbtiQuantityTableView.snp.makeConstraints {
            $0.top.equalTo(hbtiQuantityTopView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(4 * 66)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
}

extension HBTIQuantitySelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesQuantity.quantities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HBTIQuantitySelectCell.reuseIdentifier, for: indexPath) as! HBTIQuantitySelectCell
        
        if indexPath.row == 2 {
            cell.configureCell(text: NotesQuantity.quantities[indexPath.row].text, isThirdCell: true)
        } else {
            cell.configureCell(text: NotesQuantity.quantities[indexPath.row].text)
        }

        cell.quantityButton.rx.tap
            .map { HBTIQuantitySelectReactor.Action.didSelectQuantity(indexPath) }
            .bind(to: reactor!.action)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
