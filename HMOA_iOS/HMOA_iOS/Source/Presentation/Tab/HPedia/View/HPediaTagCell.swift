//
//  TagCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import UIKit

import ReactorKit

class HPediaTagCell: UICollectionViewCell, View {
    
    
    typealias Reactor = HPediaTagCellReactor
    
    var disposeBag = DisposeBag()
    
    

    static let identifier = "HPediaTagCell"
    
    //MAKR: - Properties
    let nameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - SetUp
    private func setUpUI() {
        contentView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        self.layer.addBorder([.top], color: .customColor(.HPediaCellColor), width: 1)
    }
    
    private func setAddView() {
        contentView.addSubview(nameLabel)
    }
    
    private func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        nameLabel.text = reactor.currentState.name
    }
}
