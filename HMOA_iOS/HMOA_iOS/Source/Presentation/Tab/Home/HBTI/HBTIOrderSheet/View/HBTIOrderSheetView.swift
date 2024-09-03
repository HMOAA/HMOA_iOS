//
//  HBTIOrderSheetView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/26/24.
//

import UIKit

final class HBTIOrderSheetView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let view1 = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    
    private let view2 = UIView().then {
        $0.backgroundColor = UIColor.orange
    }
    private let view3 = UIView().then {
        $0.backgroundColor = UIColor.yellow
    }
    private let view4 = UIView().then {
        $0.backgroundColor = UIColor.green
    }
    private let view5 = UIView().then {
        $0.backgroundColor = UIColor.blue
    }
    
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
        
//        setUI()
//        setAddView()
//        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {

    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        [
//         ordererInfoView,
         view1,
         view2,
         view3,
         view4,
         view5
//         dividingLineView1,
//         addressView,
//         dividingLineView2,
//         productInfoView,
//         dividingLineView3,
//         totalPaymentView,
//         dividingLineView4,
//         agreementView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
//        ordererInfoView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview()
//        }
        scrollView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.trailing.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.trailing.equalToSuperview()
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        /// 여깅ㅁ러ㅣㅁㄴ어린ㅁㅇ라ㅓ
        ///ㅁㄴㅇㄹㄴㅁㄹㅁㄴㄹㅁㅇ
        ///ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㄹㅇ
        
        view1.snp.makeConstraints {
            $0.top.equalToSuperview()
//            $0.width.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300)
//            $0.bottom.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
        
        view2.snp.makeConstraints {
            $0.top.equalTo(view1.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
//            $0.width.equalToSuperview()
            $0.height.equalTo(300)
//            $0.bottom.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
        view3.snp.makeConstraints {
            $0.top.equalTo(view2.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
//            $0.width.equalToSuperview()
            $0.height.equalTo(300)
//            $0.bottom.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
        view4.snp.makeConstraints {
            $0.top.equalTo(view3.snp.bottom)
//            $0.horizontalEdges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
//            $0.bottom.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
        view5.snp.makeConstraints {
            $0.top.equalTo(view4.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
//            $0.width.equalToSuperview()
            $0.height.equalTo(300)
            $0.bottom.equalToSuperview()
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
