//
//  HBTIZipCodeViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/31/24.
//

import UIKit
import SnapKit
import WebKit

protocol HBTIZipCodeViewControllerDelegate: AnyObject {
    func didReceiveAddress(postCode: String, address: String)
}

class HBTIZipCodeViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: HBTIZipCodeViewControllerDelegate?
    
    private lazy var webView: WKWebView = {
        let configuration = configureWebView()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        
        return webView
    }()
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        loadWebView()
        
        webView.configuration.userContentController.add(self, name: "callBackHandler")
    }
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         webView,
         indicator
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalTo(webView)
        }
    }
    
    private func configureWebView() -> WKWebViewConfiguration {
        let contentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        return configuration
    }
    
    private func loadWebView() {
        guard let url = URL(string: "https://kasroid.github.io/Kakao-Postcode/") else { return }
        webView.load(URLRequest(url: url))
        indicator.startAnimating()
    }
    
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "callBackHandler")
    }
}

extension HBTIZipCodeViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            let postCode = data["zonecode"] as? String ?? ""
            let address = data["roadAddress"] as? String ?? ""
            
            delegate?.didReceiveAddress(postCode: postCode, address: address)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension HBTIZipCodeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
