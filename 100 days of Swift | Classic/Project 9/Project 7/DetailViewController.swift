//
//  DetailViewController.swift
//  Project 7
//
//  Created by Volodymyr Khuda on 27.01.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial scale=1">
        <style>
        body { font-size: 150%; }
        p.main {
          text-align: justify;
        }
        </style>
        </head>
        <body>
        <center><h4>\(detailItem.title)</h4></center>
        <p><center><i>Signagure count: \(detailItem.signatureCount)</i></center></p>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}
