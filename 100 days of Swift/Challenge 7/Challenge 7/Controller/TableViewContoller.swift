//
//  ViewController.swift
//  Challenge 7
//
//  Created by Volodymyr Khuda on 12.03.2021.
//

import UIKit
import SwipeCellKit
import RealmSwift

class TableViewContoller: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Private properties
    
    private var notesManager = NotesManager()
    private var notes: Results<Note>?
    private var realm = try! Realm()
    
    private var notesCountLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = realm.objects(Note.self)
        
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.toolbar.tintColor = .orange
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Notes"
        
        notesCountLabel = UILabel()
        notesCountLabel.text = "Notes"
        notesCountLabel.font = .systemFont(ofSize: 11)
        
        let notesCounttoolBarItem = UIBarButtonItem(customView: notesCountLabel)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addNewNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        
        toolbarItems = [spacer, notesCounttoolBarItem, spacer, addNewNoteButton]
        
        navigationController?.isToolbarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.toolbar.setBackgroundImage(nil, forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.toolbar.setShadowImage(nil, forToolbarPosition: UIBarPosition.any)
        
        if let notes = notes {
            notesCountLabel.text = "\(notes.count) Notes"
        }
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    @objc private func createNewNote() {
        let newNote = Note()
        newNote.title = ""
        newNote.changeDate = Date()
        newNote.text = ""
        
        notesManager.saveInDB(object: newNote)
        
        tableView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.detailViewContollerID) as? DetailViewController {
            vc.note = newNote
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
//            as! SwipeTableViewCell
//        cell.delegate = self
        
        if let note = notes?[indexPath.row] {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            let now = dateFormatter.string(from: note.changeDate)
            
            
            cell.textLabel?.text = note.title
            cell.detailTextLabel?.text = now
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.detailViewContollerID) as? DetailViewController {
            vc.note = notes?[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

// MARK: - SwipeTableViewCell Delegate Methods

//extension TableViewContoller: SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructiveAfterFill
//        options.transitionStyle = .border
//        return options
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            do {
//                try self.realm.write() {
//                    self.realm.delete(self.notes![indexPath.row])
//                }
//            } catch {
//                print("Error with deleting node \(error.localizedDescription)")
//            }
//            if let notes = self.notes {
//                self.notesCountLabel.text = "\(notes.count) Notes"
//            }
//        }
//
//        deleteAction.image = UIImage(systemName: "trash")
//
//
//        return [deleteAction]
//
//    }
//
//}
