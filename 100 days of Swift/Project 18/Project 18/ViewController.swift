//
//  ViewController.swift
//  Project 18
//
//  Created by Volodymyr Khuda on 01.03.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(1, 2, separator: "-")
        
        assert(1 == 1, "Math failure!")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
        
    }


}

