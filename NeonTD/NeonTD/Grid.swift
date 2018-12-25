//
//  Grid.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/11/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

// Wrapper class for 2D array of spritenodes that make up the map grid
class Grid: CustomStringConvertible {
    
    // Used for determining where towers can be placed
    // and where enemies can run
    var grid: [[GridSpace]]
    
    // The visible correspondent to the grid
    var nodes: [[SKSpriteNode]]
    
    // Grid properties
    var path: Path
    var gridSize = CGSize.zero
    var nodeSize: CGSize = CGSize.zero
    
    // For testing (CustomStringConvertible)
    public var description: String {
        var str = ""
        for row in nodes {
            str = "\(str)ROW START\n"
            for node in row {
                str = "\(str)||\(node)\n"
            }
            str = "\(str)||\nROW END\n\n\n"
        }
        str = "\(str)\(path.description)\n"
        return str
    }
    
    init(grid: [[GridSpace]], path: Path) {
        self.path = path
        self.grid = grid
        
        var rowNum = 0
        var colNum = 0
        nodes = []
        self.gridSize = UIScreen.main.bounds.size
        self.nodeSize = CGSize(width: gridSize.width / CGFloat(grid[0].count), height: gridSize.height / CGFloat(grid.count))
        for row in grid {
            colNum = 0
            var rowNodes: [SKSpriteNode] = []
            for space in row {
                // Access space to get more detailed info about a grid space
                let node = SKSpriteNode()
                let pos = calcPos(row: rowNum, col: colNum)
                node.position = pos
                node.size = nodeSize
                node.alpha = 0.1
                node.color = space.placeable ? UIColor.green : UIColor.red
                node.name = space.name + "_[\(rowNum),\(colNum)]"
                node.isHidden = true
                rowNodes.append(node)
                colNum += 1
            }
            nodes.append(rowNodes)
            rowNum += 1
        }
    }
    
    private func calcPos(row: Int, col: Int) -> CGPoint {
        // Offsets are because of anchor points at (0.5, 0.5)
        let xOffset = nodeSize.width / CGFloat(2)
        let yOffset = nodeSize.height / CGFloat(2)
        
        let x = CGFloat(col) * nodeSize.width + xOffset
        let y = CGFloat(row) * nodeSize.height + yOffset
        return CGPoint(x: x, y: y)
    }
    
    func startPos() -> CGPoint {
        let start = path.startPos
        let reverse = path.isReverse
        switch path.startType {
        case .row:
            let col = reverse ? grid[start].count - 1 : 0
            return pos(row: start, col: col)
        case .col:
            let row = reverse ? grid.count - 1 : 0
            return pos(row: row, col: start)
        }
    }
    func endPos() -> CGPoint {
        let end = path.endPos
        let reverse = path.isReverse
        switch path.endType {
        case .row:
            let col = reverse ? 0 : grid[end].count - 1
            return pos(row: end, col: col)
        case .col:
            let row = reverse ? 0 : grid.count - 1
            return pos(row: row, col: end)
        }
    }
    
    func showTiles() {
        for row in nodes {
            for node in row {
                node.isHidden = false
            }
        }
    }
    
    func hideTiles() {
        for row in nodes {
            for node in row {
                node.isHidden = true
            }
        }
    }
    
    func rowAndCol(at pos: CGPoint) -> (Int, Int) {
        let row: Int = Int(floor(pos.y / nodeSize.height))
        let col: Int = Int(floor(pos.x / nodeSize.width))
        return (row, col)
    }
    
    func pos(row: Int, col: Int) -> CGPoint {
        // Offset to give point in the middle of given position
        let xOffset = nodeSize.width / CGFloat(2)
        let yOffset = nodeSize.height / CGFloat(2)
        
        let xPos: CGFloat = CGFloat(col) * nodeSize.width + xOffset
        let yPos: CGFloat = CGFloat(row) * nodeSize.height + yOffset
        return CGPoint(x: xPos, y: yPos)
    }
    
    func validFrame(rect: CGRect) -> Bool {
        var valid = true
        
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        let bL = CGPoint(x: minX, y: minY)
        let tR = CGPoint(x: maxX, y: maxY)
        
        let bottomLeft = rowAndCol(at: bL)
        let topRight = rowAndCol(at: tR)
        
        let minRow = bottomLeft.0
        let minCol = bottomLeft.1
        // Add one because rowAndCol rounds down
        let maxRow = topRight.0
        let maxCol = topRight.1
        
        for i in minRow...maxRow {
            let row = grid[i]
            for j in minCol...maxCol {
                if !row[j].placeable {
                    valid = false
                }
            }
        }
        return valid
    }
    
    func invalidateGrid(in rect: CGRect) {
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        let bL = CGPoint(x: minX, y: minY)
        let tR = CGPoint(x: maxX, y: maxY)
        
        let bottomLeft = rowAndCol(at: bL)
        let topRight = rowAndCol(at: tR)
        
        let minRow = bottomLeft.0
        let minCol = bottomLeft.1
        // Add one because rowAndCol rounds down
        let maxRow = topRight.0
        let maxCol = topRight.1
        
        for i in minRow...maxRow {
            for j in minCol...maxCol {
                grid[i][j] = ObstacleSpace()
                nodes[i][j].color = UIColor.red
            }
        }
    }
    
    func verticies() -> [CGPoint] {
        let offset: CGFloat = 10
        
        var rows = path.rows
        var cols = path.cols
        for (index, row) in rows.enumerated() {
            rows[index] = row + Int.random(in: 0..<path.width)
        }
        
        for (index, col) in cols.enumerated() {
            cols[index] = col + Int.random(in: 0..<path.width)
        }
        let tempXRow = path.isReverse ? pos(row: rows.last!, col: grid[0].count - 1).x + offset + nodeSize.width : pos(row: rows.first!, col: 0).x - offset
        let tempXCol = path.isReverse ? pos(row: grid.count - 1, col: cols.last!).x : pos(row: 0, col: cols.first!).x
        let tempYRow = path.isReverse ? pos(row: rows.last!, col: grid[0].count - 1).y: pos(row: rows.first!, col: 0).y
        let tempYCol = path.isReverse ? pos(row: grid.count - 1, col: cols.last!).y + offset + nodeSize.height : pos(row: 0, col: cols.first!).x - offset
        let startPosX = path.startType == .row ? tempXRow : tempXCol
        let startPosY = path.startType == .row ? tempYRow : tempYCol
        var verticies = [CGPoint(x: startPosX, y: startPosY)]
        
        switch path.startType {
        case .row:
            for (index, col) in cols.enumerated() {
                let pos1 = pos(row: rows[index], col: col)
                verticies.append(pos1)
                if (rows.count > index) {
                    let pos2 = pos(row: rows[index + 1], col: col)
                    verticies.append(pos2)
                }
            }
        case .col:
            for (index, row) in rows.enumerated() {
                let pos1 = pos(row: row, col: cols[index])
                verticies.append(pos1)
                if (rows.count > index) {
                    let pos2 = pos(row: row, col: cols[index + 1])
                    verticies.append(pos2)
                }
            }
        }
        let endPosY = path.startType == .row ? verticies.last!.y : gridSize.height + offset
        let endPosX = path.startType == .row ? gridSize.width + offset : verticies.last!.x
        verticies.append(CGPoint(x: endPosX, y: endPosY))
        return verticies
    }
    // Soley for testing
    func removeTiles() {
        for row in nodes {
            for node in row {
                node.removeFromParent()
            }
        }
    }
}
