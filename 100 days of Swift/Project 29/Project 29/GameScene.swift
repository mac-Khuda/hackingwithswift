//
//  GameScene.swift
//  Project 29
//
//  Created by Volodymyr Khuda on 04.04.2021.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
    
}

var player1ScoreLabel: SKLabelNode!
var player2ScoreLabel: SKLabelNode!

var player1Score: Int = 0 {
    didSet {
        player1ScoreLabel.text = "SCORE: \(player1Score)"
        
    }
    
}

var player2Score: Int = 0 {
    didSet {
        player2ScoreLabel.text = "SCORE: \(player2Score)"
        
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buildings = [BuidingNode]()
    
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    
    var currentPlayer = 1
    
    var windLabel: SKLabelNode!
    
    var wind = 0 {
        didSet {
            if wind > 0 {
                windLabel.text = "Wind: > \(wind) "
            } else {
                windLabel.text = "Wind: < \(abs(wind))"
            }
        }
    }
    
    var banana: SKSpriteNode!
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
        
        player1ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        player1ScoreLabel.text = "SCORE: \(player1Score)"
        player1ScoreLabel.position = CGPoint(x: 8, y: 8)
        player1ScoreLabel.horizontalAlignmentMode = .left
        player1ScoreLabel.zPosition = 2
        addChild(player1ScoreLabel)
        
        player2ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        player2ScoreLabel.text = "SCORE: \(player2Score)"
        player2ScoreLabel.position = CGPoint(x: 850, y: 8)
        player2ScoreLabel.horizontalAlignmentMode = .left
        player2ScoreLabel.zPosition = 2
        addChild(player2ScoreLabel)
        
        windLabel = SKLabelNode(fontNamed: "Chalkduster")
        windLabel.position = CGPoint(x: 512, y: 600)
        windLabel.zPosition = 2
        windLabel.horizontalAlignmentMode = .center
        addChild(windLabel)
        wind = Int.random(in: -75...75)
        
        physicsWorld.contactDelegate = self
        
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuidingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setUp()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degress: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequance = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequance)
            
            let impulse = CGVector(dx: cos(radians) * speed + Double(wind) / 5, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequance = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequance)
            
            let impulse = CGVector(dx: cos(radians) * -speed + (Double(wind) / 5), dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
        
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
        
    }
    
    func deg2rad(degress: Int) -> Double {
        return Double(degress) * .pi / 180
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
            
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            player2Score += 1
            destroy(player: player1)
            
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            player1Score += 1
            destroy(player: player2)
            
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuidingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlyaer()
    }
    
    func destroy(player: SKSpriteNode) {
        if player1Score == 3 || player2Score == 3 {
            isGameOver = true
        }
        
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
            
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        if !isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController?.currentGame = newGame
                
                self.changePlyaer()
                newGame.currentPlayer = self.currentPlayer
                
                let transition = SKTransition.crossFade(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
                
            }
            
        } else {
            windLabel.removeFromParent()
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.zPosition = 2
            gameOverLabel.position = CGPoint(x: 512, y: 600)
            gameOverLabel.horizontalAlignmentMode = .center
            addChild(gameOverLabel)
            
        }
        
    }
    
    func changePlyaer() {
        if currentPlayer == 1 {
            currentPlayer = 2
            
        } else {
            currentPlayer = 1
            
        }
        viewController?.activatePlayer(number: currentPlayer)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlyaer()
        }
    }
    
}
