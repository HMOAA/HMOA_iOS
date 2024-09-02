//
//  HBTIOrderSheetView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/26/24.
//

import UIKit

final class HBTIOrderSheetView: UIView {
    
    // MARK: - UI Components
    
    private let ordererInfoView = HBTIOrdererInfoView()
    
    private let dividingLineView1 = HBTIOrderDividingLineView(color: .black)
    
    private let addressView = HBTIAddressView()
    
    private let dividingLineView2 = HBTIOrderDividingLineView(color: .black)
    
    private let productInfoView = HBTIProductInfoView()
    
    private let dividingLineView3 = HBTIOrderDividingLineView(color: .black)

    private let totalPaymentView = HBTITotalPaymentView()
    
    private let dividingLineView4 = HBTIOrderDividingLineView(color: .black)
    
    private let agreementView = HBTIAgreementView()
    
    // MARK: - Initialization
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {

    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         ordererInfoView,
         dividingLineView1,
         addressView,
         dividingLineView2,
         productInfoView,
         dividingLineView3,
         totalPaymentView,
         dividingLineView4,
         agreementView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        ordererInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView1.snp.makeConstraints {
            $0.top.equalTo(ordererInfoView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView1.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView2.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        productInfoView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView2.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView3.snp.makeConstraints {
            $0.top.equalTo(productInfoView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalPaymentView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView3.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView4.snp.makeConstraints {
            $0.top.equalTo(totalPaymentView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        agreementView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView4.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
