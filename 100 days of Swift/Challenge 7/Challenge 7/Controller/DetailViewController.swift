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
    
    private var isDoneButtonAdded = false
    
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(addButton), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        
        isDoneButtonAdded = false
        
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
        let activityController = UIActivityViewController(activityItems: [note?.text ?? ""], applicationActivities: [])
        present(activityController, animated: true, completion: nil)
    }
    
    @objc func adjustKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
            navigationItem.rightBarButtonItems?.remove(at: 0)
            isDoneButtonAdded = false
            
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
        
    }
    
    @objc func addButton(notification: Notification) {
        if !isDoneButtonAdded {
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
            navigationItem.rightBarButtonItems?.insert(doneButton, at: 0)
            isDoneButtonAdded = true
            
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
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
