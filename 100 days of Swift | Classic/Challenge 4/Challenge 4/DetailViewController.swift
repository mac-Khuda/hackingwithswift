//
//  DetailViewController.swift
//  Challenge 4
//
//  Created by Volodymyr Khuda on 13.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var path: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safePath = path {
            
            imageView.image = UIImage(contentsOfFile: safePath.path)
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
