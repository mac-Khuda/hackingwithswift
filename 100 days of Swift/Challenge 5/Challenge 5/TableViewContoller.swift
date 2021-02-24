//
//  ViewController.swift
//  Challenge 5
//
//  Created by Volodymyr Khuda on 24.02.2021.
//

import UIKit

class TableViewContoller: UITableViewController {
    
    // MARK: - Public Properties
    
    var countries = [Country]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Facts"
        
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                parseJSON(with: data)
            }
        }
        
    }
    
    // MARK: - Public Methods
    
    func parseJSON(with data: Data) {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode([Country].self, from: data) {
            countries = decodedData
            print("done")
            print(decodedData)
        }
    }
    
    // MARK: - TableViewD ata Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].countryName
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            vc.country = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

