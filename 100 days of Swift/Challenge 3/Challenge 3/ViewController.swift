//
//  ViewController.swift
//  Challenge 3
//
//  Created by Volodymyr Khuda on 03.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var rightAnswer: String?
    var labelScore: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(labelScore)"
        }
    }
    
    var levelScore: Int = 0
    
    var errorsCount: Int = 0 {
        willSet {
            if newValue == 7 {
                let ac = UIAlertController(title: "The end...", message: "All heads are dead, restart?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (alert) in
                    self.level = 1
                    self.loadLevel()
                }))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    var level: Int = 1 {
        willSet {
            if newValue == 3 {
                let ac = UIAlertController(title: "The end", message: "Levels are ended. Wait for update, thank you!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (alert) in
                    self.level = 1
                    self.loadLevel()
                    self.labelScore = 0
                }))
                present(ac, animated: true, completion: nil)
            }
        }
        didSet {
            loadLevel()
        }
    }
    
    var characterButtons = [UIButton]()
    var usedButtons = [UIButton]()
    var scoreLabel: UILabel!
    
    @IBOutlet weak var lifesLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(labelScore)"
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            
            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        let height = 80
        let width = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = .systemFont(ofSize: 36)
                letterButton.setTitle("W", for: .normal)
                letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
                
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                
                characterButtons.append(letterButton)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
        
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        if let character = sender.titleLabel?.text {
            if (rightAnswer?.firstIndex(of: Character(character))) != nil {
                var characters = Array(title!)
                let rightCharacters = Array(rightAnswer!)
                for (i, letter) in rightCharacters.enumerated() {
                    if String(letter) == character {
                        characters[i] = letter
                        title = String(characters)
                        usedButtons.append(sender)
                        sender.isHidden = true
                        labelScore += 1
                        levelScore += 1
                        if levelScore == rightAnswer?.count {
                            level += 1
                        }
                    }
                }
            } else {
                var lifes = lifesLabel.text!.components(separatedBy: " ")
                lifes[errorsCount] = "😵"
                lifesLabel.text = lifes.joined(separator: " ")
                errorsCount += 1
                sender.isHidden = true
                usedButtons.append(sender)
                
            }
        }
        
    }
    
    func loadLevel() {
        for button in usedButtons {
            button.isHidden = false
        }
        usedButtons = []
        lifesLabel.text = "😄 😄 😄 😄 😄 😄 😄"
        var characterBits = [String]()
        errorsCount = 0
        levelScore = 0
        
        if let fileLevelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: fileLevelURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let charactes = parts[0]
                    let answer = parts[1]
                    
                    title = (String(repeating: "?", count: answer.count))
                    rightAnswer = answer
                    
                    let bits = charactes.components(separatedBy: "|")
                    characterBits += bits
                    
                }
            }
        }
        
        self.characterButtons.shuffle()
        if characterButtons.count == characterBits.count {
            for i in 0..<self.characterButtons.count {
                self.characterButtons[i].setTitle(characterBits[i], for: .normal)
            }
        }
        
    }
    
}

