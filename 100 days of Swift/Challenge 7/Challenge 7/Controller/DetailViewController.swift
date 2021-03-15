//
//  DetailViewController.swift
//  Challenge 7
//
//  Created by Volodymyr Khuda on 12.03.2021.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Private Properties
    
    private var notesManager = NotesManager()
    private var realm = try! Realm()
    
    
    // MARK: - Public Properties
    
    var note: Note?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            textView.text = note.text
        }
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote(note:)))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        let pencilButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: nil, action: nil)
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
        
        
        toolbarItems = [shareButton, spacer, cameraButton, spacer, pencilButton, spacer, deleteButton]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if note?.text != textView.text {
            
            let headLine = textView.text.components(separatedBy: "\n")
            let part = headLine[0]
            
            print(part)
            
            saveNote(part: part)
            
        }
        
        if note?.text == "" {
            print("Deleted")
            if let note = note {
                do {
                    try realm.write() {
                        realm.delete(note)
                    }
                } catch {
                    print("Can't delete note in realm DB: \(error)")
                }
            }
        }
        
    }
    
    @objc func deleteNote(note: Note?) {
        textView.text = ""
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func shareNote() {
        let activityController = UIActivityViewController(activityItems: [note?.text], applicationActivities: [])
        present(activityController, animated: true, completion: nil)
    }
    
    func saveNote(part: String) {
        do {
            try realm.write() {
                note?.title = part
                note?.text = textView.text
                note?.changeDate = Date()
            }
        } catch {
            print("Can't save note in realm database: \(error)")
        }
    }
    
}
