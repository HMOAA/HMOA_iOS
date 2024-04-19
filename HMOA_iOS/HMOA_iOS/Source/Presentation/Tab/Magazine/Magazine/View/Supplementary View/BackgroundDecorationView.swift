//
//  BackgroundDecorationView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/2/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class BackgroundDecorationView: UICollectionReusableView {
    
    static let identifier = "BackgroundDecorationView"
    
    let backgroundView = UIImageView().then {
        $0.backgroundColor = .customColor(.gray4)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateImageFromNotification), name: .updateBackgroundImage, object: nil)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateImageFromNotification() {
        if let url = MagazineBannerImageURLManager.shared.imageURL {
            backgroundView.kf.setImage(with: URL(string: url))
        }
    }
    
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setAddView() {
        [backgroundView].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
