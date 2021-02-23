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
    var highScore = 0
    var score = 0
    var correctAnswer = 0
    var questionScore = 0
    var allTimeSocre = 0
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScore = defaults.integer(forKey: "highScore")
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gamecontroller"), style: .plain, target: self, action: #selector(showFolAllTimeScore))
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        UIView.animate(withDuration: 1) {
            self.button1.transform = .identity
            self.button2.transform = .identity
            self.button3.transform = .identity
        } completion: { finished in
            
        }
        
        title = "\(countries[correctAnswer].uppercased()) | Your score: \(score)"
    }
    
    @objc func showFolAllTimeScore() {
        let ac = UIAlertController(title: "Your score for all time", message: "Score: \(allTimeSocre)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String = "Answer"
        questionScore += 1
        
        if questionScore == 10 {
            var message = ""
            if score < highScore {
                message = "You answered 10 question! Your endscore: \(score)"
            } else {
                message = "You answered 10 question! Your endscore: \(score). Gongratulations! You beat high score: \(highScore)"
                highScore = score
                defaults.set(highScore, forKey: "highScore")
            }
            let ac = UIAlertController(title: "Good game", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New game", style: .default, handler: { [weak self] _ in
                
                self?.questionScore = 0
                self?.score = 0
                self?.askQuestion()
            }))
            present(ac, animated: true, completion: nil)
            
        }

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { finished in
            if sender.tag == self.correctAnswer {
                self.title = "Correct"
                self.score += 1
                self.allTimeSocre += 1
                self.askQuestion()
            } else {
                title = "Wrong"
                self.score -= 1
                self.allTimeSocre -= 1
                let ac = UIAlertController(title: title, message: "Wrong flag! This is flag of \(self.countries[sender.tag].capitalized)...", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.askQuestion))
                self.present(ac, animated: true, completion: nil)
            }
        }
        
    }
}


