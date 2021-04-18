//
//  TableViewController.swift
//  Project 4
//
//  Created by Volodymyr Khuda on 19.01.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    let websites = ["apple.com", "google.com", "microsoft.com", "amazon.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "web") as? ViewController {
            vc.websites = websites
            vc.websiteToLoad = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
