//
//  Person.swift
//  Project 10
//
//  Created by Volodymyr Khuda on 05.02.2021.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
