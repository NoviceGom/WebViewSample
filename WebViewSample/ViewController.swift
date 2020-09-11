//
//  ViewController.swift
//  WebViewSample
//
//  Created by Hong js on 2020/09/10.
//  Copyright © 2020 Hong joo seok. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var contentsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    
    var menuHeight: CGFloat = 50
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Install WebView in contentsView
        webView = WKWebView()
        webView!.translatesAutoresizingMaskIntoConstraints = false

        contentsView.addSubview(webView!)

        webView!.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 0).isActive = true
        webView!.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: 0).isActive = true
        webView!.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 0).isActive = true
        webView!.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: 0).isActive = true

        //Register Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = URLRequest(url: URL(string: "https://twitter.com/intent/tweet?text=Hello%20world")!)
        
        //let request = URLRequest(url: URL(string:"https://www.facebook.com/dialog/share?app_id=145634995501895&display=popup&href=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2F&redirect_uri=https%3A%2F%2Fdevelopers.facebook.com%2Ftools%2Fexplorer")!)
        
        webView!.load(request)

    }

    @objc func keyboardWillShow(notification: Notification)
    {
        var _kbSize:CGSize!
        
        if let info = notification.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                let screenSize = UIScreen.main.bounds
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                
                let bottomSafeArea = self.view.safeAreaInsets.bottom
                print("keyboardWillShow kbSize - \(_kbSize.height) \(bottomSafeArea)")
                
                self.menuBottomConstraint.constant = _kbSize.height - bottomSafeArea
                
                //Adjust menu's height
                webView!.scrollView.contentInset.bottom = menuHeight
                webView!.scrollView.verticalScrollIndicatorInsets.bottom = menuHeight
                
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification)
    {
        print("keyboardWillHide")
        self.view.endEditing(true)
        
        webView!.scrollView.contentInset.bottom = 0
        webView!.scrollView.verticalScrollIndicatorInsets.bottom = 0
        self.menuBottomConstraint.constant = 0
        
        self.view.layoutIfNeeded()
    }
    
    
}

