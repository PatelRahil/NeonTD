//
//  Projectile.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/23/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class Projectile: Sprite {
    let type: pType
    let speed: Double
    
    
    /// Initializer for a Projectile with the given image name.
    ///
    /// - Parameters:
    ///   - imageName: Name of the Projectile's image.
    ///   - pos: The initial position of the Projectile.
    ///   - type: The Projectile's type.
    ///   - speed: The Projectile's movement speed.
    ///   - size: The Projectile's size.
    init(imageName: String, pos: CGPoint, type: pType, speed: Double, size: CGSize) {
        self.speed = speed
        self.type = type
        super.init(imageName: imageName, size: size, pos: pos)
        sprite.zPosition = -1
    }
    
    
    /// Initializer for a basic square projectile (for testing purposes).
    ///
    /// - Parameters:
    ///   - size: The Projectile's size.
    ///   - pos: The initial position of the Projectile.
    ///   - type: The Projectile's type.
    ///   - speed: The Projectile's movement speed.
    init(size: CGSize, pos: CGPoint, type: pType, speed: Double) {
        self.speed = speed
        self.type = type
        super.init(color: .white, size: size, pos: pos)
    }
    
    
    /// Runs the given action on the Projectile's sprite.
    ///
    /// - Parameter action: The action to run.
    func fire(action: SKAction) {
        sprite.run(action)
    }
}


/// Enum for Projectile types.
///
/// - basic: The basic projectile type.
enum pType {
    case basic
}
