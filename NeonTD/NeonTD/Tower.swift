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

    /// Initializer for basic square Tower
    /// (For testing)
    ///
    /// - Parameters:
    ///   - type: Type of Tower
    ///   - size: Size of Tower
    ///   - pos: Position of Tower
    ///   - upgradeCosts: Array of upgrade costs for each level
    ///   - initialLevel: Initial level of Tower
    ///   - initialCost: Price of buying the Tower
    ///   - upgradeImages: Array of image names for each upgrade level
    ///   - range: Range of Tower
    ///   - fireRate: How quick the Tower fires
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
    
    
    /// Initializer for a Tower with given image names
    ///
    /// - Parameters:
    ///   - type: Type of Tower
    ///   - pos: Position of Tower
    ///   - upgradeCosts: Array of upgrade costs for each level
    ///   - initialLevel: Initial level of Tower
    ///   - initialCost: Price of buying the Tower
    ///   - upgradeImages: Array of image names for each upgrade level
    ///   - range: Range of Tower
    ///   - fireRate: How quick the Tower fires
    ///   - size: Size of Tower
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
    
    
    /// Determines where the Tower should aim.
    ///
    /// - Parameters:
    ///   - enemies: Array of enemies on screen (possible targets)
    ///   - isReverse: Whether or not the map is reversed
    /// - Returns: A tuple
    ///   - .1: Whether or not there is a target
    ///   - .2: The target's position (CGPoint.zero by default)
    func target(enemies: [Enemy], isReverse: Bool) -> (Bool,CGPoint) {
        var target = CGPoint.zero
        var targetedEnemy: Enemy?
        var hasTarget = false
        let rangeCircle = SKShapeNode(circleOfRadius: CGFloat(range) + 5)
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
         /*
        if let e = targetedEnemy {
            e.setColor(color: .yellow)
        }
         */
        return (hasTarget, target)
    }
    
    
    /// Upgrades the tower
    /// - Updates the color or image of the Tower
    func upgrade() {
        if !isMaxLevel {
            upgradeLevel += 1
            updateColor()
            updateImage()
        }
    }
    
    
    /// Changes the color of the Tower's Sprite
    private func updateColor() {
        super.setColor(color: upgradeColors[upgradeLevel])
    }
    
    
    /// Changes the image of the Tower's Sprite
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
    
    func enableShooting(isReverse: Bool)
    func upgrade()
}
