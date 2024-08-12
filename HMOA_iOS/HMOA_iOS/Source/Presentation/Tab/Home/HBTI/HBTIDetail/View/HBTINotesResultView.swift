//
//  HBTINotesResultView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/6/24.
//

import UIKit
import SnapKit
import Then

class HBTINotesResultView: UIView {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "선택한 향료"
        $0.font = .customFont(.pretendard_bold, 20)
        $0.textColor = .black
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    private let totalPriceLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 16)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 18)
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel, stackView, totalPriceLabel, nextButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(totalPriceLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Public Methods
    func configureView(with notes: [NoteItem]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        notes.forEach { note in
            let noteView = NoteItemView(note: note)
            stackView.addArrangedSubview(noteView)
        }
        
        let totalPrice = notes.reduce(0) { $0 + $1.price }
        totalPriceLabel.text = "총 금액 : \(totalPrice.formattedWithSeparator())원"
    }
}

// MARK: - NoteItemView
class NoteItemView: UIView {
    private let containerView = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 8
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 16)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
        $0.textColor = .customColor(.gray5)
        $0.numberOfLines = 0
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 16)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    init(note: NoteItem) {
        super.init(frame: .zero)
        setupUI()
        configureWith(note)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        [imageView, titleLabel, subtitleLabel, priceLabel].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(12)
            $0.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureWith(_ note: NoteItem) {
        imageView.image = UIImage(named: note.imageName)
        titleLabel.text = note.title
        subtitleLabel.text = note.subtitle
        priceLabel.text = "\(note.price.formattedWithSeparator())원"
    }
}

// MARK: - Helper
extension Int {
    func formattedWithSeparator() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

// MARK: - NoteItem Model
struct NoteItem: Equatable {
    let imageName: String
    let title: String
    let subtitle: String
    let price: Int
}
