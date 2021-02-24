//
//  countries.swift
//  Challenge 5
//
//  Created by Volodymyr Khuda on 24.02.2021.
//

import Foundation

struct Country: Codable {
    let countryName: String
    let capital: String
    let size: Int
    let population: Int
    let currency: String
}
