//
//  GameScene.swift
//  Project 26
//
//  Created by Volodymyr Khuda on 23.03.2021.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var levelNodes = [SKSpriteNode]()
    
    var isInPortal = false
    var portalsPositions: [CGPoint] = []
    var portalsCount = 0
        
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            
        }
    }
    
    var level = 1
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        loadLevel()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Couldn't find level\(level).txt in the app bundle")
            
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Couldn't load level1.txt from the app bundle")
        }
        
        removeObjectsFromMap()
        
        createPlayer()
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    createBlock(position: position)
                    
                } else if letter == "v" {
                    createVortex(position: position)
                    
                } else if letter == "s" {
                    createStar(position: position)
                    
                } else if letter == "f" {
                    //load finishPoint
                    createFinish(position: position)
                } else if letter == "p" {
                    createPortal(position: position)
                    
                } else if letter == " " {
                    //this is an empte space, do nothing
                } else {
                    fatalError("Unkwnon level letter: \(letter)")
                }
            }
        }
    }
    
    func createBlock(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        
        levelNodes.append(node)
        
        addChild(node)
    }
    
    func createVortex(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        levelNodes.append(node)
        
        addChild(node)
    }
    
    func createFinish(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        
        levelNodes.append(node)
        
        addChild(node)
    }
    
    func createStar(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        node.position = position
        
        levelNodes.append(node)
        
        addChild(node)
    }
    
    func createPortal(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.name = "portal\(portalsCount)"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        portalsCount += 1
        portalsPositions.append(node.position)
        
        levelNodes.append(node)
        
        addChild(node)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        levelNodes.append(player)
        
        addChild(player)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
            
        }
        #endif
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerColided(with: nodeB)
        } else if nodeB == player {
            playerColided(with: nodeA)
        }
        
    }
    
    func playerColided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            
            isGameOver = true
            
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequance = SKAction.sequence([move, scale, remove])
            
            player.run(sequance) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
            
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
            
        } else if node.name == "finish" {
            level += 1
            loadLevel()
            
        } else if node.name == "portal0" {
            print("colided portal")
            if !isInPortal {
                teleport(to: "portal1")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.isInPortal = false
                }
                
            }
            
        } else if node.name == "portal1" {
            print("colided portal")
            if !isInPortal {
                teleport(to: "portal0")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.isInPortal = false
                }
            }
        }
        
    }
    
    func teleport(to portal: String) {
        switch portal {
        case "portal0":
            print("portal0")
            isInPortal = true
            print(portalsPositions[0])
            player.removeFromParent()
            player.position = portalsPositions[0]
            addChild(player)
//            isInPortal = false
        case "portal1":
            print("portal1")
            isInPortal = true
            print(portalsPositions[1])
            player.removeFromParent()
            player.position = portalsPositions[1]
            addChild(player)
//            isInPortal = false
        default:
            print("Not colided")
        }
    }
    
    func removeObjectsFromMap() {
        for node in levelNodes {
            node.removeFromParent()
        }
    }

}
