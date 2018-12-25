//
//  Tower.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/10/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit
class Tower: Sprite, CustomStringConvertible {
    let upgradeColors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    
    let type: tType
    let upgradeImages: [String]
    let upgradeCosts: [Int]
    let cost: Int
    let range: Double
    let fireRate: Double
    var upgradeLevel: Int
    var upgradeCost: Int {
        return upgradeCosts[upgradeLevel]
    }
    var isMaxLevel: Bool {
        return upgradeLevel == upgradeImages.count - 1
    }
    
    var enemies: [Enemy] = []
    
    // For testing (CustomStringConvertible)
    public var description: String {
        return "Tower: <Tower> type: \(type), cost: \(cost), upgrade level: \(upgradeLevel)\nSprite: \(super.sprite)"
    }

    // Testing (pre-texture creation init)
    init(type: tType, size: CGSize, pos: CGPoint, upgradeCosts: [Int], initialLevel: Int, initialCost: Int, upgradeImages: [String], range: Double, fireRate: Double) {
        self.upgradeLevel = initialLevel
        self.type = type
        self.upgradeCosts = upgradeCosts
        self.cost = initialCost
        self.upgradeImages = upgradeImages
        self.range = range
        self.fireRate = fireRate
        super.init(color: upgradeColors[upgradeLevel], size: size, pos: pos)
    }
    
    init(type: tType, pos: CGPoint, upgradeCosts: [Int], initialLevel: Int, initialCost: Int, upgradeImages: [String], range: Double, fireRate: Double, size: CGSize) {
        self.upgradeLevel = initialLevel
        self.type = type
        self.upgradeCosts = upgradeCosts
        self.upgradeImages = upgradeImages
        self.cost = initialCost
        self.range = range
        self.fireRate = fireRate
        super.init(imageName: upgradeImages[upgradeLevel], size: size, pos: pos)
    }
    
    func target(enemies: [Enemy], isReverse: Bool) -> (Bool,CGPoint) {
        var target = CGPoint.zero
        var targetedEnemy: Enemy?
        var hasTarget = false
        let rangeCircle = SKShapeNode(circleOfRadius: CGFloat(range) + 5)
        let transform = CGAffineTransform(translationX: sprite.position.x, y: sprite.position.y)
        rangeCircle.position = sprite.position
        for enemy in enemies {
            let pos = enemy.sprite.position

            if rangeCircle.contains(pos) {
                if hasTarget {
                    let inFront = enemy.isInFrontOf(other: targetedEnemy!, isReverse: isReverse)
                    target = inFront ? enemy.sprite.position : targetedEnemy!.sprite.position
                    targetedEnemy = inFront ? enemy : targetedEnemy
                } else {
                    target = pos
                    targetedEnemy = enemy
                    hasTarget = true
                }
            }
        }
        
        
         // For testing
         
        if let e = targetedEnemy {
            e.setColor(color: .yellow)
        }
         
        return (hasTarget, target)
    }
        
    func upgrade() {
        if !isMaxLevel {
            upgradeLevel += 1
            updateColor()
            updateImage()
        }
    }
    private func updateColor() {
        super.setColor(color: upgradeColors[upgradeLevel])
    }
    private func updateImage() {
        super.setImage(imageName: upgradeImages[upgradeLevel])
    }
}

protocol TowerProtocol {
    var uCosts: [Int] { get }
    var iCost: Int { get }
    var uImages: [String] { get }
    var iLevel: Int { get }
    var r: Double { get }
    
    func shoot(isReverse: Bool)
    func upgrade()
}
