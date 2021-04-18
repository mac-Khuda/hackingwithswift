//
//  ActionViewController.swift
//  Extension
//
//  Created by Volodymyr Khuda on 04.03.2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var script: UITextView!
    
    var savedScripts: [String] = []
    
    var savedText: String?
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        savedScripts = defaults.array(forKey: "savedScripts") as? [String] ?? [String]()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSavedScripts))
        navigationItem.rightBarButtonItems = [doneButton, plusButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(showScripts))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        if let safePageURL = self?.pageURL {
                            if let scriptText = defaults.string(forKey: "\(safePageURL)script") {
                                self?.script.text = scriptText
                                
                            }
                        }
                        self?.title = self?.pageTitle
                        
                        if self?.savedText != nil {
                            self?.script.text = self?.savedText!
                            print(self?.savedText!)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item], completionHandler: nil)
        
        if let convertedPageURL = URL(string: pageURL) {
            print("Done")
            let defaults = UserDefaults.standard
            defaults.set(convertedPageURL, forKey: pageURL)
            defaults.set(script.text, forKey: "\(pageURL)script")
            
            savedScripts.append(script.text)
            defaults.set(savedScripts, forKey: "savedScripts")
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func showScripts() {
        let ac = UIAlertController(title: "Scripts", message: "Choose one of prewritten scripts", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show title", style: .default, handler: { [weak self] (alert) in
            self?.script.text = "alert(document.title)"
            self?.done()
        }))
        ac.addAction(UIAlertAction(title: "Show URL", style: .default, handler: { [weak self] (alert) in
            self?.script.text = "alert(document.url)"
            self?.done()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func showSavedScripts() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "scriptsTableView") as? SciptsTableViewController {
            vc.savedScripts = savedScripts
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
