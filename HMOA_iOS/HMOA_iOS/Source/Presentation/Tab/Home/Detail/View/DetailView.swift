//
//  DetailView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then

class DetailView: UIView {
    
    // MARK: - Properies
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let perfumeInfoView = PerfumeInfoView()
    let perfumeMiddleInfoView = PerfumeMiddleInfoView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Functions

extension DetailView {
    func configureUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = .white

        [   perfumeInfoView,
            perfumeMiddleInfoView   ] .forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        perfumeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(380)
        }
        
        perfumeMiddleInfoView.snp.makeConstraints {
            $0.top.equalTo(perfumeInfoView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(400)
        }
    }
}
