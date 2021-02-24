//
//  DetailViewController.swift
//  Challenge 5
//
//  Created by Volodymyr Khuda on 24.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    // MARK: - Public Methods
    
    var country: Country?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFact))
        
        if let country = country {
            title = country.countryName
            countryNameLabel.text! += country.countryName
            capitalLabel.text! += country.capital
            populationLabel.text! += String(country.population)
            sizeLabel.text! += String(country.size)
            currencyLabel.text! += country.currency
            
        }
        
    }
    
    // MARK: - Public Methods
    
    @objc func shareFact() {
        let ac = UIActivityViewController(activityItems: [countryNameLabel.text!, capitalLabel.text!, populationLabel.text!, sizeLabel.text!, currencyLabel.text!], applicationActivities: [])
        present(ac, animated: true, completion: nil)
    }
    

}
