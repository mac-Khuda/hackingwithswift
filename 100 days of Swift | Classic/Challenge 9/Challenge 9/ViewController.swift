//
//  ViewController.swift
//  Challenge 9
//
//  Created by Volodymyr Khuda on 30.03.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme generator"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        
    }
    
    @objc func addPicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        showTextFields()
        
    }
    
    func showTextFields() {
        let ac = UIAlertController(title: "Write your text", message: nil, preferredStyle: .alert)
        
        ac.addTextField(configurationHandler: nil)
        ac.addTextField(configurationHandler: nil)
        
        ac.addAction(UIAlertAction(title: "Add text", style: .default, handler: { [weak self] alert in
            let renderer = UIGraphicsImageRenderer(size: (self?.imageView.image!.size)!)
            
            let finalImage = renderer.image { (ctx) in
                guard let image = self?.imageView.image else { return }
                
                image.draw(at: CGPoint(x: 0, y: 0))
                
                if let topText = ac.textFields?[0].text {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let atters: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 50),
                        .paragraphStyle: paragraphStyle,
                        .foregroundColor: UIColor.white
                        
                    ]
                    
                    let attrtibutedString = NSAttributedString(string: topText, attributes: atters)
                    attrtibutedString.draw(with: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
                    
                }
                
                if let bottomText = ac.textFields?[1].text {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let atters: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 50),
                        .paragraphStyle: paragraphStyle,
                        .foregroundColor: UIColor.white
                        
                    ]
                    
                    let attrtibutedString = NSAttributedString(string: bottomText, attributes: atters)
                    attrtibutedString.draw(with: CGRect(x: 0, y: image.size.height - attrtibutedString.size().height, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
                    
                }
                
            }
            
            self?.imageView.image = finalImage
            
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func shareMeme() {
        guard let image = imageView.image else { return }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
        
    }
    
}

