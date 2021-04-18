//
//  DetailViewController.swift
//  Project 1
//
//  Created by Volodymyr Khuda on 10.01.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No image found")
            return
        }
        
        guard let image = imageView.image else { return }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let imageForSending = renderer.image { (ctx) in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let atters: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30),
                .foregroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 0.5),
                .strokeColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                
            ]
            
            let string = "From Storm Viewer"
            let attributesString = NSAttributedString(string: string, attributes: atters)
            attributesString.draw(with: CGRect(x: 10, y: 10, width: 300, height: 100), options: .usesLineFragmentOrigin, context: nil)
            
        }
        
        guard let imageForSharingjpegData = imageForSending.jpegData(compressionQuality: 0.8) else { return }
    
        
        let vc = UIActivityViewController(activityItems: [imageForSharingjpegData, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }

}
