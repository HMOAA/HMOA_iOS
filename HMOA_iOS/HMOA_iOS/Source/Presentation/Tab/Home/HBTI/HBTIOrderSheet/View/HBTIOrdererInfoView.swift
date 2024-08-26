//
//  HBTIOrdererInfoView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/26/24.
//

import UIKit

class HBTIOrdererInfoView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
    private let nameLabel = UILabel()
    
    private let nameTextField = UITextField()
    
    private let contactLabel = UILabel()
    
    private let contactTextField = UITextField()
    
    // MARK: - Initialization
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {

    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        
    }
    
    // MARK: - Set Constraints
    
    private func setupConstraints() {
        
    }
}
