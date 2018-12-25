//
//  TempEnemy.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/23/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class TempEnemy: Enemy {
    
    init(vertexPos: [CGPoint]) {
        super.init(vertexPos: vertexPos, speed: 10, type: .temp, size: CGSize(width: 10, height: 10))
    }
}
