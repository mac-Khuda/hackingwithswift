//
//  DetailViewController.swift
//  Challenge 1
//
//  Created by Volodymyr Khuda on 16.01.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var image: UIImage?

    @IBOutlet weak var flagImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeImage = image {
            flagImageView.image = safeImage
            flagImageView.layer.borderWidth = 1
            flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
    }
    
    @objc func shareFlag() {
        guard let safeImage = flagImageView.image?.jpegData(compressionQuality: 1) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [safeImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
}
