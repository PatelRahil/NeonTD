//
//  UnplaceableSpace.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/11/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class UnplaceableSpace: GridSpace {
    init(runnable: Bool) {
        super.init(placeable: false, runnable: runnable)
    }
}
