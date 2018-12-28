//
//  GameScene.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/10/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var towers: [CircleTower] = []
    var enemies: [Enemy] = []
    var selectedTower: Tower? = nil
    var grid: Grid? = nil
    var draggedTower: Tower? = nil
    
    let towerBtn = SKSpriteNode()
    let towerMenu = SKSpriteNode()
    let roundStartBtn = SKSpriteNode()
    
    var roundCount = 0
    var isPlacingTower = false
    var isBetweenRounds = true
    var enemyID = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        self.anchorPoint = CGPoint.zero
        makeGrid()
        layoutGrid()
        setupChildren()
        
        towerMenu.isHidden = true
        addChild(towerMenu)
        addChild(towerBtn)
        addChild(roundStartBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let pos = touch.location(in: self)
        let selectedNode = atPoint(pos)
        
        // Is added at didMove(to view:) and never removed, so never nil
        let otherNode = childNode(withName: "Tower_Menu")!
        // If the tower menu is visible
        if !otherNode.isHidden {
            if let name = selectedNode.name {
                print("Touched: \(name)")
                if name.contains("template") {
                    print("Touched a template tower")
                    placingTower(pos: pos, name: name)
                    otherNode.isHidden = true
                } else if name != "Tower_Button" {
                    otherNode.isHidden = true
                }
            }
        }
        
        if isPlacingTower {
            print("Touched the screen while placing tower")
            if let tempTower = childNode(withName: "Temp_Button") {
                tempTower.position = pos
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let pos = touch.location(in: self)
        
        if isPlacingTower {
            if let tempTower = childNode(withName: "Temp_Tower") {
                let gridPos = grid!.rowAndCol(at: pos)
                let newPos = grid!.pos(row: gridPos.0, col: gridPos.1)
                let action = SKAction.move(to: newPos, duration: 0.01)
                tempTower.run(action)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let pos = touch.location(in: self)
        let selectedNode = atPoint(pos)
        
        
        if isPlacingTower {
            print("Is placing tower")
            if canPlaceTower(at: pos) {
                print("Was able to place the tower")
                let placedTowerSprite = towers.last!.sprite
                placedTowerSprite.name = "tower \(towers.count - 1)"
                placedTowerSprite.zPosition = 0
                grid?.invalidateGrid(in: placedTowerSprite.frame)
                grid!.hideTiles()
                isPlacingTower = false
                
                // Removes the range circle from the tower
                if let circle = placedTowerSprite.childNode(withName: "Range_Circle") {
                    circle.removeFromParent()
                }
            } else if wantsToStopPlacingTower(at: pos) {
                print("Stopped placing tower")
                // Removes the range circle from the tower
                if let circle = towers.last!.sprite.childNode(withName: "Range_Circle") {
                    circle.removeFromParent()
                }
                towers.removeLast()
                isPlacingTower = false
            } else {
                print("Can't place a tower here and not trying to stop placing a tower")
            }
        } else {
            // If the popup menu is visible
            if let otherNode = childNode(withName: "Upgrade Popup") {
                print("NAME: \(selectedNode.name)")

                if let name = selectedNode.name {
                    if name == "upgrade" {
                        // Touches the upgrade button
                        if let tower = selectedTower {
                            if !tower.isMaxLevel {
                                selectedTower!.upgrade()
                                selectedTower = nil
                                otherNode.removeFromParent()
                            }
                        }
                    } else if name == "sell" {
                        // Touches the sell button
                        sellTower()
                        otherNode.removeFromParent()
                        selectedTower = nil
                    } else if name != "Upgrade Popup" {
                        // Touches outside the pop up
                        otherNode.removeFromParent()
                        if let tower = selectedTower {
                            // Removes the range circle from around the tower
                            if let circle = tower.sprite.childNode(withName: "Range_Circle") {
                                circle.removeFromParent()
                            }
                        }
                        selectedTower = nil
                    } else {
                    }
                } else {
                    // Touches outside the pop up where the name is nil
                    otherNode.removeFromParent()
                    if let tower = selectedTower {
                        // Removes the range circle from around the tower
                        if let circle = tower.sprite.childNode(withName: "Range_Circle") {
                            circle.removeFromParent()
                        }
                    }
                    selectedTower = nil
                }
            }
            
            if let name = selectedNode.name {
                if name == "Tower_Button" {
                    towerMenu.isHidden = false
                } else if name.contains("tower") {
                    let towerNum: Int = Int(String(name.last!))!
                    let tower = towers[towerNum]
                    selectedTower = tower
                    addRangeCircle(on: tower)
                    let upgradePopup = UpgradePopup(tower: tower, height: frame.height, width: frame.width)
                    
                    // In case a tower is selected while another tower was already selected
                    addChild(upgradePopup.popup)
                } else if name == "Round_Start_Button" && isBetweenRounds {
                    startRound()
                } else {
                    
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for tower in towers {
            tower.enemies = enemies
        }
        
        // Allowers round start button to be pressed when there are no alive enemies left
        if !isBetweenRounds && enemies.isEmpty {
            print("\n\n\n\nFLAPJACKS\n\n\n")
            isBetweenRounds = true
            roundStartBtn.texture = SKTexture(imageNamed: "Round_Start_Button")
        }
    }
    
    private func removeTower() {
        if let sTower = selectedTower {
            var removed = false
            var count = 0
            for tower in towers {
                if tower.sprite.name == sTower.sprite.name {
                    towers.remove(at: count)
                    removed = true
                } else if removed {
                    // Shifts the names down by one
                    let towerNum: Int = Int(String(tower.sprite.name!.last!))!
                    tower.sprite.name! = "tower \(towerNum - 1)"
                } else {
                    // Before the tower is removed
                    count += 1
                }
            }
            sTower.sprite.removeFromParent()
        }
    }
    
    private func sellTower() {
        // Add other things that happen when a tower is sold
        removeTower()
    }
    
    private func canBuyTower() -> Bool {
        // Determine if the player can afford the tower
        return true
    }
    
    private func canPlaceTower(at pos: CGPoint) -> Bool {
        // Determine if the player can place a tower at the given position
        let tower = towers.last!
        let frame = tower.sprite.frame
        return grid!.validFrame(rect: frame)
    }
    
    private func wantsToStopPlacingTower(at pos: CGPoint) -> Bool {
        // Check if pos is within the bounds of the delete sprite's frame
        return false
    }
    
    private func layoutGrid() {
        for row in grid!.nodes {
            for node in row {
                addChild(node)
            }
        }
    }
    
    private func spawnEnemy(type: eType) {
        switch type {
        case .temp:
            let enemy = TempEnemy(vertexPos: self.grid!.verticies())
            enemy.sprite.name = "\(enemy.type) Enemy ID: \(enemyID)"
            enemyID += 1
            enemies.append(enemy)
            self.addChild(enemy.sprite)
            let removeAction = SKAction.run {
                self.enemies.removeAll(where: {$0.sprite.name == enemy.sprite.name})
            }
            let action = SKAction.sequence([enemy.moveAction(), removeAction])
            enemy.runAction(action: action)
        default:
            print("Unsupported enemy type '\(type)'")
        }
        
    }
    
    private func killEnemy(enemy: Enemy) {
        enemies.removeAll(where: {$0.sprite.name == enemy.sprite.name})
        enemy.kill()
    }
    
    private func startRound() {
        if roundCount < Waves.waves.count {
            isBetweenRounds = false
            roundStartBtn.texture = SKTexture(imageNamed: "Round_Start_Button_Inactive")
            let wave = Waves.waves[roundCount]
            var counter = 0
            let timer = Timer.scheduledTimer(withTimeInterval: wave.separation, repeats: true) { (t) in
                if counter < wave.count {
                    self.spawnEnemy(type: wave.type)
                    counter += 1
                } else {
                    t.invalidate()
                }
            }
            timer.fire()
            roundCount += 1
        }
    }
    
    // Do stuff while placing a tower
    private func placingTower(pos: CGPoint, name: String) {
        // Name has format "type_template_index"
        // Where type is the type of tower selected
        // And index is the location of the tower in the Type.allCases array
        let index = Int(String(name.last!))!
        let type = tType.allCases[index]
        
        switch type {
        case .circle:
            let tower = CircleTower(pos: pos)
            towers.append(tower)
            tower.sprite.name = "Temp_Tower"
            tower.sprite.zPosition = 0.5
            tower.enableShooting(isReverse: grid!.path.isReverse)
            addChild(tower.sprite)
            addRangeCircle(on: tower)
            grid!.showTiles()
        case .triangle:
            print("Not implemented yet")
        case .sqaure:
            print("Not implemented yet")
        default:
            print("Something went wrong")
        }
                
        isPlacingTower = true
    }
    
    private func addRangeCircle(on tower: Tower) {
        // Range circle
        let range = tower.range
        let circle = SKShapeNode(circleOfRadius: CGFloat(range))
        circle.strokeColor = .white
        circle.fillColor = .clear
        circle.position = CGPoint.zero
        circle.zPosition = -1
        circle.name = "Range_Circle"
        tower.sprite.addChild(circle)
    }
    
    // For setting up some elements of UI
    private func setupChildren() {
        setupTowerMenu()
        setupTowerBtn()
        setupRoundStartBtn()
    }
    private func setupTowerMenu() {
        towerMenu.texture = SKTexture(imageNamed: "Tower_Menu")
        towerMenu.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
        towerMenu.position = CGPoint(x: towerMenu.frame.width / 2, y: towerMenu.frame.height / 2)
        towerMenu.zPosition = 0.5
        towerMenu.name = "Tower_Menu"
        
        let offset: CGFloat = 20
        for index in 0...tType.allCases.count - 1 {
            let towerNode = TowerType.towers[index]
            let nodeImg = (towerNode["image_names"] as! [String])[0]
            let node = SKSpriteNode(imageNamed: nodeImg)
            node.name = "\(towerNode["type"] as! tType)_template_\(index)"
            node.size = CGSize(width: 50, height: 50)
            let multiplier = CGFloat(index + 1)
            let xPos: CGFloat = (node.frame.width + offset) * multiplier - towerMenu.frame.width / 2
            node.position = CGPoint(x: xPos, y: 0)
            node.zPosition = 1
            towerMenu.addChild(node)
            print(node.name!)
        }
    }
    private func setupTowerBtn() {
        towerBtn.texture = SKTexture(imageNamed: "Tower_Button")
        towerBtn.size = CGSize(width: 40, height: 40)
        towerBtn.position = CGPoint(x: towerBtn.size.width / 2 + 20, y: towerBtn.size.height / 2 + 20)
        towerBtn.name = "Tower_Button"
    }
    private func setupRoundStartBtn() {
        roundStartBtn.texture = SKTexture(imageNamed: "Round_Start_Button")
        roundStartBtn.size = CGSize(width: 40, height: 40)
        roundStartBtn.position = CGPoint(x: size.width - roundStartBtn.size.width / 2 - 40, y: roundStartBtn.size.height / 2 + 20)
        roundStartBtn.name = "Round_Start_Button"
    }
    
    // For creating test grids
    private func makeGrid() {
        let scale = 2
        var nodeGrid: [[GridSpace]] = []
        let path = Path(rows: [4, 12, 20], cols: [16, 30], width: 3, isReverse: false, startType: .row, endType: .col)
        for row in 0...(16 * scale) {
            // Access rows and columns for creating test maps with conditionals
            var gridRow: [GridSpace] = []
            for col in 0...(35 * scale) {
                if isPathSpace(cRow: row, cCol: col, path: path) {
                    let gridSpace = PathSpace()
                    gridRow.append(gridSpace)
                } else {
                    let gridSpace = PlaceableSpace()
                    gridRow.append(gridSpace)
                }
            }
            nodeGrid.append(gridRow)
        }
        grid = Grid(grid: nodeGrid, path: path)
        print(grid)
    }
    
    // Currently only properly functioning for if rows.count = cols.count + 1
    private func isPathSpace(cRow: Int, cCol: Int, path: Path) -> Bool {
        let width = path.width
        let rows = path.rows
        let cols = path.cols
        var isPath = false
        
        if rows.count == cols.count + 1 {
            for (index, row) in rows.enumerated() {
                if (index == rows.count - 1) {
                    isPath = isPath || cRow - row >= 0 && cRow - row < width && cCol >= cols[index - 1]
                } else if (index == 0) {
                    isPath = isPath || cRow - row >= 0 && cRow - row < width && cCol < cols[index]
                } else {
                    isPath = isPath || cRow - row >= 0 && cRow - row < width && cCol >= cols[index - 1] && cCol < cols[index] + width
                }
            }
            
            for (index, col) in cols.enumerated() {
                isPath = isPath || cCol - col >= 0 && cCol - col < width && cRow >= rows[index] && cRow < rows[index + 1] + width
            }
        } else if cols.count == rows.count + 1 {
            for (index, col) in cols.enumerated() {
                if (index == cols.count - 1) {
                    isPath = isPath || cCol - col >= 0 && cCol - col < width && cRow >= rows[index - 1]
                } else if (index == 0) {
                    isPath = isPath || cCol - col >= 0 && cCol - col < width && cRow < rows[index]
                } else {
                    isPath = isPath || cCol - col >= 0 && cCol - col < width && cRow >= rows[index - 1] && cRow < rows[index] + width
                }
            }
            
            for (index, row) in cols.enumerated() {
                isPath = isPath || cRow - row >= 0 && cRow - row < width && cCol >= cols[index] && cCol < cols[index + 1] + width
            }
        }
        
        return isPath
    }
    
    private func printTowers() {
        for tower in towers {
            print("\(tower)\n")
        }
    }
}
