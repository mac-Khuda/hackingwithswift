//
//  ViewController.swift
//  Challenge 1
//
//  Created by Volodymyr Khuda on 16.01.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    var pictures: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png") {
                var itemForAppend = item
                for _ in 0...3 {
                    itemForAppend.removeLast()
                }
                pictures.append(itemForAppend)
            }
        }
        print(pictures)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row].uppercased()
        
        cell.imageView?.image = UIImage(named: pictures[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.image = UIImage(named: pictures[indexPath.row])
            vc.navigationItem.title = pictures[indexPath.row].uppercased()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

