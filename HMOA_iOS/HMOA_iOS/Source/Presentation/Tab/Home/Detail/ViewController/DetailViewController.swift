//
//  DetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then

class DetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    let detailView = DetailView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle(title: "조 말론", color:  .white, isHidden: false)
        configureUI()
    }
}

// MARK: - Functions
extension DetailViewController {
    func configureUI() {
        
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
