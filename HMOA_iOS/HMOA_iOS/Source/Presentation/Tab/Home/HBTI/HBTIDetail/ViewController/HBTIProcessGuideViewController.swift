//
//  HBTIDetailViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/29/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit

class HBTIProcessGuideViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let hbtiProcessInnerView = HBTIProcessGuideView()
    private let hbtiSelectionView = HBTIQuantitySelctionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setupView()
        setupConstraints()
    }
    
    private func setUI() {
        setClearBackNaviBar("향BTI", .black)
    }
    
    private func setupView() {
        [hbtiProcessInnerView
         ].forEach {
            view.addSubview($0)
        }

    }
    
    private func setupConstraints() {
        hbtiProcessInnerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: HBTIDetailReactor) {
        hbtiProcessInnerView.nextButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.showQuantitySelectionView()
            })
            .disposed(by: disposeBag)
    }
    
    private func showQuantitySelectionView() {
        let quantitySelectionView = HBTIQuantitySelctionView()
        let quantitySelectionVC = UIViewController()
        quantitySelectionVC.view = quantitySelectionView
        navigationController?.pushViewController(quantitySelectionVC, animated: true)
    }

}
