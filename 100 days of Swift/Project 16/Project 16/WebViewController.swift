//
//  WebViewController.swift
//  Project 16
//
//  Created by Volodymyr Khuda on 26.02.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var capital: String?
    
    override func loadView() {
        webView = WKWebView()
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(capital ?? "Kyiv")") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
