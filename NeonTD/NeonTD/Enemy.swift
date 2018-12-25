//
//  Enemy.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/13/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class Enemy: Sprite {
    // Positions where the enemy will change directions
    // Includes starting and ending position
    var vertexPos: [CGPoint]
    let type: eType
    let speed: Double
    
    var isFirst = false
    
    init(imageName: String, vertexPos: [CGPoint], speed: Double, type: eType, size: CGSize) {
        self.vertexPos = vertexPos
        self.speed = speed
        self.type = type
        if let iPos = vertexPos.first {
            super.init(imageName: imageName, size: size, pos: iPos)
        } else {
            print("Invalid vertex positions for enemy movement:\n\(vertexPos)")
            // So vertexPos has a first element for the move function
            self.vertexPos.append(CGPoint.zero)
            super.init(imageName: imageName, size: size, pos: CGPoint.zero)
        }
    }
    
    // For testing
    init(vertexPos: [CGPoint], speed: Double, type: eType, size: CGSize) {
        self.vertexPos = vertexPos
        self.speed = speed
        self.type = type
        if let iPos = vertexPos.first {
            super.init(color: .red, size: CGSize(width: 10, height: 10), pos: iPos)
        } else {
            print("Invalid vertex positions for enemy movement:\n\(vertexPos)")
            // So vertexPos has a first element for the move function
            self.vertexPos.append(CGPoint.zero)
            super.init(color: .red, size: size, pos: CGPoint.zero)
        }
    }
    
    func setVertexPos(positions: [CGPoint]) {
        vertexPos = positions
    }
    
    func moveAction() -> SKAction {
        let velocity = 10 * speed
        var actions = [SKAction]()
        var prevPos = vertexPos.first!
        for pos in vertexPos {
            var diff: Double = 0
            if prevPos.x != pos.x {
                diff = abs(Double(pos.x - prevPos.x))
            } else {
                diff = abs(Double(pos.y - prevPos.y))
            }
            let duration = diff/velocity
            let tempAction = SKAction.move(to: pos, duration: duration)
            actions.append(tempAction)
            prevPos = pos
        }
        actions.append(SKAction.removeFromParent())
        let sequence = SKAction.sequence(actions)
        return sequence
    }
    
    func runAction(action: SKAction) {
        sprite.run(action)
    }
    
    func kill() {
        sprite.removeAllActions()
        sprite.removeFromParent()
    }
    
    // Also returns false if this instance is at the same position as the other
    func isInFrontOf(other: Enemy, isReverse: Bool) -> Bool {
        let pos1 = self.sprite.position
        let pos2 = other.sprite.position
        if pos1 == pos2 {
            return false
        } else {
            return isReverse ? pos1.x > pos2.x || pos1.y > pos2.x : pos1.x < pos2.x || pos1.y < pos2.y
        }
    }
}

struct Waves {
    static let waves = [
        EnemyWave(count: 10, separation: 1, type: .temp),
        EnemyWave(count: 25, separation: 0.5, type: .temp),
        EnemyWave(count: 100, separation: 0.2, type: .temp)
    ]
}
