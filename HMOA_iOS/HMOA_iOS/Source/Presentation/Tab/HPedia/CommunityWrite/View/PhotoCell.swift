//
//  PhotoCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/11/01.
//

import UIKit

import Then
import SnapKit
import RxSwift

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properites
    static let identifier = "PhotoCell"
    
    var disposeBag = DisposeBag()
    
    
    var isZoomEnabled: Bool = false {
        didSet {
            setUpViews()
        }
    }
    
    //MARK: - UI Components
    private lazy var scrollView = UIScrollView().then {
        
        $0.delegate = self
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 3.0
        $0.alwaysBounceVertical = false
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = true
        $0.zoomScale = 1.0
        
    }
    
    let imageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
    }
    
    private let xButtonBackView = UIView().then {
        $0.layer.cornerRadius = 13
        $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
    }
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x")?.withTintColor(.white), for: .normal)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    //MARK: - SetUp
    
    
    private func setUpViews() {
        
        if subviews.isEmpty {
            if isZoomEnabled {
                scrollView.addSubview(imageView)
                addSubview(scrollView)
                scrollView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                imageView.snp.makeConstraints { make in
                    make.width.equalTo(scrollView.snp.width)
                    make.height.equalTo(scrollView.snp.height)
                    make.edges.equalToSuperview()
                }
            } else {
                addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    func configureXButton() {
        
        addSubview(xButtonBackView)
        addSubview(xButton)
        
        xButtonBackView.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(8)
            make.width.height.equalTo(26)
        }

        xButton.snp.makeConstraints { make in
            make.centerX.equalTo(xButtonBackView.snp.centerX)
            make.centerY.equalTo(xButtonBackView.snp.centerY)
        }
    }
    
    func updateCell(_ image: UIImage) {
        imageView.image = image
    }
}

extension PhotoCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func handleDoubleTap() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let center = imageView.center
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: center)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
