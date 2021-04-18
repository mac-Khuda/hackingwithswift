//
//  NotesManager.swift
//  Challenge 7
//
//  Created by Volodymyr Khuda on 12.03.2021.
//

import Foundation
import RealmSwift

struct NotesManager {
    let realm = try! Realm()
    
    func saveInDB(object: Object) {
        do {
            try realm.write() {
                realm.add(object)
            }
        } catch {
            print("Error with saving object to realm: \(error)")
        }
    }
    
}
