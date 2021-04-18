//
//  ViewController.swift
//  Project 28
//
//  Created by Volodymyr Khuda on 02.04.2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!
    
    var isPasswordCreated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Create password", style: .plain, target: self, action: #selector(createPassword))
        isPasswordCreated = KeychainWrapper.standard.bool(forKey: "isPasswordCreated") ?? false
        
        if isPasswordCreated {
            navigationItem.leftBarButtonItem?.isEnabled = false
            
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    @IBAction func authenticateTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    } else {
                        //error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please, try again or enter password.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                        ac.addAction(UIAlertAction(title: "Use password", style: .default, handler: { (alert) in
                            let passwordAC = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
                            passwordAC.addTextField(configurationHandler: nil)
                            passwordAC.addAction(UIAlertAction(title: "Authenticate", style: .default, handler: { (alert2) in
                                if passwordAC.textFields?[0].text == KeychainWrapper.standard.string(forKey: "password") {
                                    self?.unlockSecretMessage()
                                } else {
                                    let wrongPasswordAC = UIAlertController(title: "Wrong password", message: nil, preferredStyle: .alert)
                                    wrongPasswordAC.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (alert3) in
                                        self?.dismiss(animated: true, completion: nil)
                                        self?.present(passwordAC, animated: true, completion: nil)
                                    }))
                                    wrongPasswordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                    self?.present(wrongPasswordAC, animated: true, completion: nil)
                                }
                            }))
                            passwordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self?.dismiss(animated: true, completion: nil)
                            self?.present(passwordAC, animated: true, completion: nil)
                        }))
                        self?.present(ac, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric configuration", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            ac.addAction(UIAlertAction(title: "Use password", style: .default, handler: { (alert) in
                let passwordAC = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
                passwordAC.addTextField(configurationHandler: nil)
                passwordAC.addAction(UIAlertAction(title: "Authenticate", style: .default, handler: { (alert2) in
                    if passwordAC.textFields?[0].text == KeychainWrapper.standard.string(forKey: "password") {
                        self.unlockSecretMessage()
                    } else {
                        let wrongPasswordAC = UIAlertController(title: "Wrong password", message: nil, preferredStyle: .alert)
                        wrongPasswordAC.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (alert3) in
                            self.dismiss(animated: true, completion: nil)
                            self.present(passwordAC, animated: true, completion: nil)
                        }))
                        wrongPasswordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(wrongPasswordAC, animated: true, completion: nil)
                    }
                }))
                passwordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.dismiss(animated: true, completion: nil)
                self.present(passwordAC, animated: true, completion: nil)
            }))
            present(ac, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func adjustForKeyboard(notifiaction: Notification) {
        guard let keyboardValue = notifiaction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notifiaction.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
            
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
        
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        
        secret.resignFirstResponder()
        secret.isHidden = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        title = "Nothing to see here"
    }
    
    @objc func createPassword() {
        let message = "Enter password for the app.\nVerify your password in second textfield."
        let ac = UIAlertController(title: "Create your password", message: message, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (alert) in
            if ac.textFields?[0].text == ac.textFields?[1].text {
                if ac.textFields?[0].text != "" {
                    if let password = ac.textFields?[0].text {
                        KeychainWrapper.standard.set(password, forKey: "password")
                        KeychainWrapper.standard.set(true, forKey: "isPasswordCreated")
                        self?.navigationItem.leftBarButtonItem?.isEnabled = false
                    }
                } else {
                    self?.dismiss(animated: true, completion: nil)
                    let blankPasswordAC = UIAlertController(title: "You can't create password like this", message: nil, preferredStyle: .alert)
                    blankPasswordAC.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] (alert) in
                        self?.dismiss(animated: true, completion: nil)
                        self?.createPassword()
                    }))
                    blankPasswordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self?.present(blankPasswordAC, animated: true)
                }
            } else {
                self?.dismiss(animated: true, completion: nil)
                let passwordsNotMatchingAC = UIAlertController(title: "Passwords doesn't match", message: "Please, enter correct password in both textfields.", preferredStyle: .alert)
                passwordsNotMatchingAC.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] (alert) in
                    self?.dismiss(animated: true, completion: nil)
                    self?.createPassword()
                }))
                passwordsNotMatchingAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(passwordsNotMatchingAC, animated: true)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
}

