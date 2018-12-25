//
//  EnemyWave.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/23/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class EnemyWave {
    var count: Int
    var separation: Double
    var type: eType
    
    init(count: Int, separation: Double, type: eType) {
        self.count = count
        self.separation = separation
        self.type = type
    }
}
