//
//  ViewController.swift
//  Project 1
//
//  Created by Volodymyr Khuda on 22.12.2020.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recomendApp))
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadPictures()
            self?.load()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                let picture = Picture(name: item, timesShowed: 0)
                pictures.append(picture)
            }
        }
        //        pictures.sort()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = "Image showed: \(pictures[indexPath.row].timesShowed)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pictures[indexPath.row].timesShowed += 1
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.navigationItem.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
        save()
    }
    
    @objc func recomendApp() {
        let recomendation = "Hello! If you want too share great pictures of nature - please, contact to @khuda_vm via Telegram or xuda01@gmail.com via email. Thank you for you support!"
        
        let vc = UIActivityViewController(activityItems: [recomendation], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "Pictures")
        }
    }
    
    func load() {
        let jsonDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "Pictures") as? Data {
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedData)
            } catch {
                print("Error with loading data: \(error)")
            }
        }
    }
    
}

