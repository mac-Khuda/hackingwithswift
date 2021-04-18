//
//  SciptsTableViewController.swift
//  Extension
//
//  Created by Volodymyr Khuda on 07.03.2021.
//

import UIKit

class SciptsTableViewController: UITableViewController {
    
    var savedScripts: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return savedScripts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = savedScripts?[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "actionVC") as? ActionViewController {
            vc.savedText = savedScripts?[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
