//
//  GameScene.swift
//  Challenge 6
//
//  Created by Volodymyr Khuda on 03.03.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    
    var isGameOver = false
    
    var timeRemaining = 60 {
        didSet {
            timerLabel.text = "Time remaining: \(timeRemaining)"
            if timeRemaining == 0 {
                timer?.invalidate()
                let gameOver = SKSpriteNode(imageNamed: "game-over")
                gameOver.position = CGPoint(x: 512, y: 384)
                gameOver.zPosition = 2
                addChild(gameOver)
                isGameOver = true
            }
        }
    }
    
    var timerLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletsLabel: SKLabelNode!
    
    var bulletsRemaining = 6 {
        didSet {
            bulletsLabel.text = "Bullets remaining: \(bulletsRemaining)"
        }
    }
    
    var reloadButton: SKLabelNode!
    
    
    let ducks = ["target1", "target2", "target3"]
    
    var timer: Timer?
    
    override func didMove(to view: SKView) {
        
        let woodBackground = SKSpriteNode(imageNamed: "wood-background")
        woodBackground.position = CGPoint(x: 512, y: 384)
        woodBackground.blendMode = .replace
        woodBackground.zPosition = -2
        woodBackground.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        addChild(woodBackground)
        
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.zPosition = 1
        curtains.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        addChild(curtains)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: 8)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "Time remaining: \(timeRemaining)"
        timerLabel.horizontalAlignmentMode = .left
        timerLabel.position = CGPoint(x: 20, y: 720)
        timerLabel.zPosition = 2
        addChild(timerLabel)
        
        bulletsLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletsLabel.text = "Bullets remaining: \(bulletsRemaining)"
        bulletsLabel.horizontalAlignmentMode = .left
        bulletsLabel.position = CGPoint(x: 625, y: 8)
        bulletsLabel.zPosition = 2
        addChild(bulletsLabel)
        
        reloadButton = SKLabelNode(fontNamed: "Chalkduster")
        reloadButton.text = "Reload"
        reloadButton.horizontalAlignmentMode = .left
        reloadButton.position = CGPoint(x: 875, y: 720)
        reloadButton.zPosition = 2
        reloadButton.name = "reload"
        addChild(reloadButton)
        
        addRow(at: CGPoint(x: 512, y: 170))
        addRow(at: CGPoint(x: 512, y: 320))
        addRow(at: CGPoint(x: 512, y: 470))
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
        
    }
    
    func addRow(at position: CGPoint) {
        let line = DuckLine()
        line.configure(at: position)
        addChild(line)
        
    }
    
    @objc func createDuck() {
        timeRemaining -= 1
        let yPositions = [200, 350, 500]
        let nodeImageName = ducks.randomElement() ?? "target1"
        let duckNode = SKSpriteNode(imageNamed: nodeImageName)
        let yPosition = yPositions.randomElement() ?? 350
        
        if yPosition == 350 {
            duckNode.position = CGPoint(x: 0, y: yPosition)
            if nodeImageName == "target3" {
                duckNode.name = "friend"
            } else if nodeImageName == "target2" {
                duckNode.name = "enemy"
            } else {
                duckNode.name = "enemy2"
                duckNode.run(SKAction.scale(by: 0.5, duration: 0.1))
            }
            addChild(duckNode)
            duckNode.run(SKAction.sequence([SKAction.moveBy(x: 1300, y: 0, duration: 5), SKAction.removeFromParent()]))
        } else {
            duckNode.position = CGPoint(x: 1024, y: yPosition)
            if nodeImageName == "target3" {
                duckNode.name = "friend"
            } else if nodeImageName == "target2" {
                duckNode.name = "enemy"
            } else {
                duckNode.name = "enemy2"
                duckNode.run(SKAction.scale(by: 0.5, duration: 0.1))
            }
            addChild(duckNode)
            duckNode.run(SKAction.sequence([SKAction.moveBy(x: -1000, y: 0, duration: 5), SKAction.removeFromParent()]))
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let tappedNodes = nodes(at: location)
        if !isGameOver {
            
            if bulletsRemaining == 0 {
                run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
                
                for node in tappedNodes {
                    if node.name == "reload" {
                        run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                            self?.bulletsRemaining = 6
                        }
                    }
                }
            } else {
                run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
                bulletsRemaining -= 1
                
                for node in tappedNodes {
                    if node.name == "friend" {
                        node.removeFromParent()
                        score -= 5
                    } else if node.name == "enemy" {
                        node.removeFromParent()
                        score += 5
                    } else if node.name == "enemy2" {
                        node.removeFromParent()
                        score += 10
                    }
                }
            }
        }
        
    }
    
}
