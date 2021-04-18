//
//  DuckLine.swift
//  Challenge 6
//
//  Created by Volodymyr Khuda on 03.03.2021.
//

import SpriteKit

class DuckLine: SKNode {
    var charNode: SKSpriteNode!
//    let ducks = ["target1", "target2", "target3"]
    
    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "water-bg")
        sprite.size = CGSize(width: 1024, height: 50)
        sprite.zPosition = -1
        addChild(sprite)
    }
    
    
}
