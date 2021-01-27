//
//  ViewController.swift
//  Challenge 2
//
//  Created by Volodymyr Khuda on 25.01.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    var shoppingList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        let addItemToListButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemToList))
        let shareListButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItems = [shareListButton, addItemToListButton]
        
    }
    
    @objc func addItemToList() {
        let ac = UIAlertController(title: "New Item", message: "Please, add new item to your list", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let text = ac.textFields?[0].text {
                self.shoppingList.insert(text, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }))
        
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func clearList() {
        shoppingList = []
        tableView.reloadData()
    }
    
    @objc func shareList() {
        let listToShare = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [listToShare], applicationActivities: [])
        present(vc, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

