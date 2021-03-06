//
//  DetailViewController.swift
//  Project 1
//
//  Created by Volodymyr Khuda on 10.01.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage?.name {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        assert(imageView.image != nil, "Image didn't load!")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
}
