//
//  LeatherBackViewController.swift
//  LAAS
//
//  Created by Promise Ochornma on 03/03/2023.
//

import UIKit
import WebKit

public class LeatherBackViewController: UIViewController, WKUIDelegate {
    
    let webView = WKWebView()
    var headerView = UIView()
    var progressView = UIProgressView()
    var delegate: LeatherBackDelegate
    var baseURL: String
    var param: LeatherBackTransactionParam
    
    public init(delegate: LeatherBackDelegate, param: LeatherBackTransactionParam) {
        self.delegate = delegate
        self.param = param
        baseURL = param.isProducEnv ? "https://pay.leatherback.co/popup/" : "https://app-aaaspaymentlink-dev.azurewebsites.net/popup/"
        super.init(nibName: nil, bundle: nil)
        self.presentationController?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addWebView()
        addHeaderView()
        loadUrl()
        
        // Do any additional setup after loading the view.
    }
    
   
    
    
    private func loadUrl(){
        guard param.amount >= 1.0 else {
            delayForDismissals(message: "Inavlid Amount")
            return
        }
        guard !param.key.isEmpty else {
            delayForDismissals(message: "Enter your public key")
            return
        }
        ////transaction-successful transaction-failed
        ///
        if let ref = param.reference {
            guard !ref.contains("transaction-successful") else {
                delayForDismissals(message: "transaction-successful cannot be used as transaction reference")
                return
            }
            
            guard !ref.contains("transaction-failed") else {
                delayForDismissals(message: "transaction-failed cannot be used as transaction reference")
                return
            }
        }
       
        if !param.showPersonalInformation {
            guard param.customerName != nil else {
                delayForDismissals(message: "Customer's Name is required whenever show personal information flag is set to false")
                return
            }
            guard let email = param.customerEmail else {
                delayForDismissals(message: "Customer's Email is required whenever show personal information flag is set to false")
                return
            }
            
            guard email.isValidEmail() else {
                delayForDismissals(message: "Customer's Email is required whenever personal information flag is set to false \n Email address is wrong")
                return
            }
        }
        guard let string = param.formatttedParam.convertCodableToString() else {
            delayForDismissals()
            return
        }
        guard let base64 = string.convertDataToString() else {
            delayForDismissals()
            return
            
        }
       
        if let theUrlValue = URL(string: "\(baseURL)\(base64)"){
            let theRequest = URLRequest(url: theUrlValue)
            webView.configuration.preferences.javaScriptEnabled = true
            webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
            self.webView.navigationDelegate = self
            self.webView.load(theRequest)
            webView.allowsBackForwardNavigationGestures = true
        }else{
            delayForDismissals()
        }
    }
    
   
    
    private func addWebView() {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.configuration.preferences.javaScriptEnabled = true
            view.addSubview(webView)
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            webView.uiDelegate = self
            webView.navigationDelegate = self
        }
    
    
    private func addHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        headerView.backgroundColor = UIColor(red: 0/255, green: 62/255, blue: 255/255, alpha: 1)
        let cancelIcon = UIImageView(image: UIImage.resourceImage(named: "Close_leather_back")?.withRenderingMode(.alwaysTemplate))
        cancelIcon.tintColor = .white
        
        cancelIcon.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(cancelIcon)
        headerView.addSubview(progressView)
        progressView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        cancelIcon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        cancelIcon.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(cancelButton)
        cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.addTarget(self, action: #selector(onCancelTapped), for: .touchUpInside)
    }
    
    @objc func onCancelTapped(){
        self.dismiss(animated: true, completion: nil)
        delegate.onLeatherBackDimissal()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: false)
        }
        
        if let key = change?[NSKeyValueChangeKey.newKey] {
        //    print("observeValue \(key)") // url value
            let urlString = "\(key)"
            if let url = URL(string: urlString){
                handleRedirectURL(url: url)
            }
        }
    }
    
    private func delayForDismissals(message: String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            self?.errorMessage(message: message)
        }
    }
    
    private func errorMessage(message: String?) {
        self.dismiss(animated: true, completion: nil)
        var error = LeatherBackErrorResponse.genericError
        if let message = message {
            error = LeatherBackErrorResponse(message: message)
        }
        self.delegate.onLeatherBackError(error: error)
    }
    
}

extension LeatherBackViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.dismiss(animated: true, completion: nil)
        delegate.onLeatherBackDimissal()
    }
}

extension LeatherBackViewController: WKNavigationDelegate {
    
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.progressView.isHidden = true;
        })
    }
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    
  
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        self.dismiss(animated: true, completion: nil)
        delegate.onLeatherBackDimissal()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true, completion: nil)
        delegate.onLeatherBackDimissal()
    }
    
    
    private func handleRedirectURL(url: URL){
        let absoluteString = url.absoluteString.lowercased()
        if absoluteString.contains("transaction-failed".lowercased()){
            var error = LeatherBackErrorResponse.genericError
            if let message = url.queryParameters?["message"] as? String{
                error = LeatherBackErrorResponse(message: message)
            }
            self.dismiss(animated: true, completion: nil)
            delegate.onLeatherBackError(error: error)
        }
        
        if absoluteString.contains("transaction-successful".lowercased()){
            guard let refId = url.queryParameters?["refId"] as? String else{
                self.dismiss(animated: true, completion: nil)
                delegate.onLeatherBackError(error: LeatherBackErrorResponse.genericError)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
                self?.dismiss(animated: true, completion: nil)
                self?.delegate.onLeatherBackSuccess(response: LeatherBackResponse(reference: refId))
            }
           
        }
    }
}
