//
//  PaymentVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 9/6/24.
//

import WebKit

final class PaymentVC: UIViewController, AlertPresenter {
    
    // MARK: Properties
    
    private let model: SubscriptionModelProtocol
    private let paymentURL: URL
    
    // MARK: UI components
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: Lifecycle
    
    init(model: SubscriptionModelProtocol, paymentURL: URL) {
        self.model = model
        self.paymentURL = paymentURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setUpUI()
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        view.addSubview(webView)
        view.backgroundColor = .background
        setUpConstraints()
        openPaymentPage()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Navigation
    
    private func openPaymentPage() {
        let request = URLRequest(url: paymentURL)
        webView.load(request)
    }
    
    private func updateSubscription(statusCode: Int) {
        Task {
            await model.updateSubscription()
            navigationController?.popToRootViewController(animated: true)
        }
    }

}

// MARK: - WKNavigationDelegate

extension PaymentVC: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let url = navigationResponse.response.url,
              url.absoluteString.contains("/api/v1/subscription/execute-payment/"),
              let httpResponse = navigationResponse.response as? HTTPURLResponse
        else {
            decisionHandler(.allow)
            return
        }
        
        if httpResponse.statusCode == 200 {
            updateSubscription(statusCode: httpResponse.statusCode)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}
