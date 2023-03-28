//
//  TotalPerfumeViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import UIKit

class TotalPerfumeViewController: UIViewController {

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.setBackItemNaviBar("전체보기")
    }
}

extension TotalPerfumeViewController {
    
    // MARK: - Configure
    func configureUI() {
        view.backgroundColor = .white
    }
}


