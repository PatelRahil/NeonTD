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
    
    init(imageName: String, pos: CGPoint, type: pType, speed: Double, size: CGSize) {
        self.speed = speed
        self.type = type
        super.init(imageName: imageName, size: size, pos: pos)
        sprite.zPosition = -1
    }
    init(size: CGSize, pos: CGPoint, type: pType, speed: Double) {
        self.speed = speed
        self.type = type
        super.init(color: .white, size: size, pos: pos)
    }
    func fire(action: SKAction) {
        sprite.run(action)
    }
}

enum pType {
    case basic
}
