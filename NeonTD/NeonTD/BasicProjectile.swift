//
//  BaseProjectile.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/23/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class BasicProjectile: Projectile {
    init(pos: CGPoint) {
        super.init(imageName: "BasicProjectile", pos: pos, type: .basic, speed: 10, size: CGSize(width: 10, height: 10))
    }
}
