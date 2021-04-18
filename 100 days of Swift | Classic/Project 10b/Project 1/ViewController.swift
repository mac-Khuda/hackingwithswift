//
//  ViewController.swift
//  Project 1
//
//  Created by Volodymyr Khuda on 22.12.2020.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recomendApp))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(authenticate))
        
        let notificatioCenter = NotificationCenter.default
        notificatioCenter.addObserver(self, selector: #selector(hidePictures), name: UIApplication.willResignActiveNotification, object: nil)
        
        authenticate()
        
    }
    
    @objc func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (succes, authError) in
                DispatchQueue.global(qos: .userInitiated).async {
                    if succes {
                        self?.loadPictures()
                    }
                }
            }
        }
    }
    
    func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PictureCell else {
            fatalError("Can't create cell")
        }
        
        cell.name.text = pictures[indexPath.item]
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        
        
        cell.imageView.layer.cornerRadius = 2
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.navigationItem.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func recomendApp() {
        let recomendation = "Hello! If you want too share great pictures of nature - please, contact to @khuda_vm via Telegram or xuda01@gmail.com via email. Thank you for you support!"
        
        let vc = UIActivityViewController(activityItems: [recomendation], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    @objc func hidePictures() {
        pictures.removeAll(keepingCapacity: true)
        collectionView.reloadData()
    }
    
}

