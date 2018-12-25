//
//  Path.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/13/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import Foundation

class Path: CustomStringConvertible {
    let rows: [Int]
    let cols: [Int]
    let width: Int
    let startType: PathType
    let endType: PathType
    // If true, path starts on top or right edge. Vice versa for false.
    let isReverse: Bool
    
    var startPos: Int {
        switch startType {
        case .row:
            return isReverse ? rows.last! - (width / 2) : rows[0] - (width / 2)
        case .col:
            return isReverse ? cols.last! - (width / 2) : cols[0] - (width / 2)
        }
    }
    
    var endPos: Int {
        switch endType {
        case .row:
            return isReverse ? rows[0] - (width / 2) : rows.last! - (width / 2)
        case .col:
            return isReverse ? cols[0] - (width / 2) : cols.last! - (width / 2)
        }
    }
    
    var description: String {
        return "Path info:\nRow positions: \(rows)\nColumn positions: \(cols)\nPath width: \(width)"
    }
    init(rows: [Int], cols: [Int], width: Int, isReverse: Bool, startType: PathType, endType: PathType) {
        self.rows = rows
        self.cols = cols
        self.width = width
        self.isReverse = isReverse
        self.startType = startType
        self.endType = endType
    }
}

enum PathType {
    case row
    case col
}
