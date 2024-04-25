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
        
        addNotificationObserver()
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
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateImageFromNotification), name: .updateBackgroundImage, object: nil)
    }
    
    @objc private func updateImageFromNotification(_ notification: Notification) {
        let url = notification.object as! String
        backgroundView.kf.setImage(with: URL(string: url))
        setDarkLayer()
    }
    
    private func setDarkLayer() {
        let darkLayer = CALayer()
        darkLayer.frame = layer.bounds
        darkLayer.backgroundColor = UIColor.black.withAlphaComponent(0.65).cgColor
        
        backgroundView.layer.sublayers = [darkLayer]
    }
}
