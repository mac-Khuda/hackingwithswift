//
//  Note.swift
//  Challenge 7
//
//  Created by Volodymyr Khuda on 12.03.2021.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var changeDate: Date = Date()
    @objc dynamic var text: String = ""
    
}
