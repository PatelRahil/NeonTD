//
//  GridSpace.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/11/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

// A base class for gride spaces
class GridSpace {    
    // User can place towers on this space
    let placeable: Bool
    // Enemies can run on this space
    let runnable: Bool
    // Name (for node creation)
    var name: String {
        if placeable {
            return "gridspace_placeable"
        } else if (runnable && !placeable) {
            return "gridspace_path"
        } else if (!runnable && !placeable) {
            return "gridspace_obstacle"
        } else {
            return "gridspace_unimplemented"
        }
    }
    
    init(placeable: Bool, runnable: Bool) {
        self.placeable = placeable
        self.runnable = runnable
    }
}
