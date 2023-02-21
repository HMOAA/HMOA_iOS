//
//  CommentViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

class CommentViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("댓글")
        configureUI()
    }
}

extension CommentViewController {
    
    func bind(reactor: CommendListReactor) {
        
    }

    
    func configureUI() {
     
        view.backgroundColor = .white
    }
}
