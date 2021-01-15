//
//  ViewController.swift
//  Project2
//
//  Created by Volodymyr Khuda on 12.01.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()) | Your score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        questionScore += 1
        
        if questionScore == 10 {
            let ac = UIAlertController(title: "Good game", message: "You answered 10 question! Your endscore: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New game", style: .default, handler: { (alert) in
                self.questionScore = 0
                self.score = 0
                self.askQuestion()
            }))
            present(ac, animated: true, completion: nil)
        }
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            askQuestion()
        } else {
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: title, message: "Wrong flag! Right answe is flag of \(countries[sender.tag].capitalized)...", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true, completion: nil)
        }
        
    }

}

