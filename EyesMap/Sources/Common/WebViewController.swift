//
//  WebViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/09/06.
//

import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController {

    var url: URL?
    
    let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        loadWebView()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadWebView() {
        guard let url = url else { return }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let request = URLRequest(url: components.url!)
        
        webView.load(request)
        
        //animation
        webView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.webView.alpha = 1
        }) { _ in
            
        }
    }
    
    
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    // 유효 도메인 체크
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
    
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}
