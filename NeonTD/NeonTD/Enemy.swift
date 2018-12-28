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
    
    
    /// Initializer for an Enemy with an image.
    ///
    /// - Parameters:
    ///   - imageName: Name of the Enemy's image.
    ///   - vertexPos: positions of the verticies of the map's path.
    ///   - speed: The Enemy's speed.
    ///   - type: The Enemy's type.
    ///   - size: The Enemy's size.
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
    
    
    /// Initializer for a basic square Enemy (for testing).
    ///
    /// - Parameters:
    ///   - vertexPos: positions of the verticies of the map's path.
    ///   - speed: The Enemy's speed.
    ///   - type: The Enemy's type.
    ///   - size: The Enemy's size.
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
    
    
    /// Update's the enemy's knowledge of the map's path's verticies.
    ///
    /// - Parameter positions: The verticies' positions.
    func setVertexPos(positions: [CGPoint]) {
        vertexPos = positions
        moveAction()
    }
    
    
    /// The enemy's action for moving from start to end on the map.
    ///
    /// - Assumes the enemy is at the starting point of the map.
    ///
    /// - Returns: Returns the action for the movement.
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
    
    
    /// Runs the given action on the Enemy Sprite.
    ///
    /// - Parameter action: The action to run.
    func runAction(action: SKAction) {
        sprite.run(action)
    }
    
    
    /// Kills the Enemy.
    ///
    /// - Removes the Enemy Sprite's actions.
    /// - Removes the Enemy Sprite from its parent node.
    func kill() {
        sprite.removeAllActions()
        sprite.removeFromParent()
    }
    
    // Also returns false if this instance is at the same position as the other.
    
    /// Whether or not this enemy is in front of the given enemy on the map's path.
    ///
    /// - Parameters:
    ///   - other: The other enemy who's position is being compared.
    ///   - isReverse: Whether or not the map is reversed.
    /// - Returns: Returns whether or not this enemy is in front of other on the path.
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
