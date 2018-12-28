//
//  CircleTower.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/10/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class CircleTower: Tower, TowerProtocol {    
    
    let size = CGSize(width: 30, height: 30)
    let uCosts = TowerType.circle["upgrade_costs"] as! [Int]
    let iCost = TowerType.circle["initial_cost"] as! Int
    let uImages = TowerType.circle["image_names"] as! [String]
    let fRate = TowerType.circle["fire_rate"] as! Double
    let r = TowerType.circle["range"] as! Double
    let iLevel = 0
    
    var fireTimer = Timer()
    
    
    /// Initializer for a Circle Tower
    ///
    /// - Parameter pos: Position of the Circle Tower
    init(pos: CGPoint) {
        super.init(type: TowerType.circle["type"] as! tType,
                   size: size,
                   pos: pos,
                   upgradeCosts: uCosts,
                   initialLevel: iLevel,
                   initialCost: iCost,
                   upgradeImages: uImages,
                   range: r,
                   fireRate: fRate)
    }
    
    
    /// Upgrades the Circle Tower
    override func upgrade() {
        super.upgrade()
    }
    
    
    /// Enables the Circle Tower to shoot
    ///
    /// - Parameter isReverse: Whether or not the map is reversed
    func enableShooting(isReverse: Bool) {
        let timeInterval = 1 / fRate
        fireTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (t) in
            // Aims the tower
            print("Enemies: \(super.enemies)")
            let (hasTarget, targetPos) = self.target(enemies: super.enemies, isReverse: isReverse)
            print("Timer firing \nHas Target?: \(hasTarget)\nTarget: \(targetPos)\n")
            if hasTarget {
                // Shoot if there is a target
                self.shootProjectile(to: targetPos)
                print("\nSHOOTING PROJECTILE\n")
            }
        }
        fireTimer.fire()
    }
    
    
    /// Disables the Circle Tower from shooting
    func disableShooting() {
        fireTimer.invalidate()
    }
    
    
    /// Shoots a projectile at a given position
    ///
    /// - Parameter pos: Where to shoot the projectile
    private func shootProjectile(to pos: CGPoint) {
        let projectile = BasicProjectile(pos: sprite.position)
        let dx = abs(Double(sprite.position.x - pos.x))
        let dy = abs(Double(sprite.position.y - pos.y))
        let angle = atan(dy/dx)
        let distance = sqrt(pow(dx, 2) + pow(dy, 2))
        let duration = distance / (100 * projectile.speed)
        let action = SKAction.move(to: pos, duration: duration)
        let removeAction = SKAction.run {
            projectile.sprite.removeFromParent()
        }
        let sequence = SKAction.sequence([action, removeAction])
        sprite.parent!.addChild(projectile.sprite)
        projectile.rotate(radians: angle)
        projectile.fire(action: sequence)
    }
    
}
