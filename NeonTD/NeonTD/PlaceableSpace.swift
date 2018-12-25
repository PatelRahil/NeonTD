//
//  PlaceableSpace.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/11/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class PlaceableSpace: GridSpace {
    init() {
        super.init(placeable: true, runnable: false)
    }
}
