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
    var separation: TimeInterval
    var type: eType
    
    
    /// Initializer for an EnemyWave.
    ///
    /// - Parameters:
    ///   - count: The number of enemies in this wave.
    ///   - separation: The timing between each enemy spawning.
    ///   - type: The enemy type
    init(count: Int, separation: TimeInterval, type: eType) {
        self.count = count
        self.separation = separation
        self.type = type
    }
}
