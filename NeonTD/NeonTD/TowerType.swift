//
//  TowerType.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/10/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import Foundation

struct TowerType {
    static let circle : [String : Any] =
        ["type":tType.circle,
        "image_names":["CircleTower_red", "CircleTower_orange", "CircleTower_yellow", "CircleTower_green", "CircleTower_blue", "CircleTower_purple"],
        "upgrade_costs":[50, 100, 200, 500],
        "initial_cost":100,
        "fire_rate":2.0,
        "range":100.0]
    static let triangle : [String : Any] =
        ["type":tType.triangle,
         "image_names":["TriangleTower_red", "TriangleTower_orange", "TriangleTower_yellow", "TriangleTower_green", "TriangleTower_blue", "TriangleTower_purple"],
         "upgrade_costs":[100, 150, 300, 550],
         "initial_cost":200,
         "fire_rate":2.0,
         "range":200.0]
    static let square : [String : Any] =
        ["type":tType.sqaure,
         "image_names":["SquareTower_red", "SquareTower_orange", "SquareTower_yellow", "SquareTower_green", "SquareTower_blue", "SquareTower_purple"],
         "upgrade_costs":[100, 200, 400, 750],
         "initial_cost":400,
         "fire_rate":2.0,
         "range":50.0]
    static let towers = [circle, triangle, square]
}


/// Enum for Tower types.
///
/// - circle: A circle tower.
/// - triangle: A triangle tower.
/// - sqaure: A square tower.
enum tType: CaseIterable {
    case circle
    case triangle
    case sqaure
}
