//
//  UpgradePopup.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/11/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class UpgradePopup {
    let popup = SKSpriteNode()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let offset: CGFloat = 20
    init(tower: Tower, height: CGFloat, width: CGFloat) {
        popup.zPosition = 1
        popup.anchorPoint = CGPoint.zero
        popup.size = CGSize(width: width / 3, height: height)
        popup.color = UIColor.white
        let image = tower.sprite.copy() as! SKSpriteNode
        image.position = CGPoint(x: popup.frame.width / 2, y: height - (offset * 3))
        let upgradeBtn = SKSpriteNode()
        upgradeBtn.size = CGSize(width: popup.frame.width - 2 * offset, height: height / 4)
        upgradeBtn.color = UIColor.gray
        upgradeBtn.position = CGPoint(x: popup.frame.width / 2, y: height / 2)
        upgradeBtn.name = "upgrade"
        
        let upgradeLabel = SKLabelNode(text: "Upgrade")
        if (tower.isMaxLevel) {
            upgradeLabel.text = "Max Level"
        }
        upgradeLabel.position = upgradeBtn.position
        upgradeLabel.fontColor = UIColor.black
        adjustLabelFontSizeToFitRect(labelNode: upgradeLabel, rect: upgradeBtn.frame)
        
        let sellBtn = SKSpriteNode()
        sellBtn.size = CGSize(width: popup.frame.width / 2, height: height / 8)
        sellBtn.color = UIColor.red
        sellBtn.position = CGPoint(x: popup.frame.width / 2, y: sellBtn.size.height / 2 + offset)
        sellBtn.name = "sell"
        
        let sellLabel = SKLabelNode(text: "Sell")
        sellLabel.position = sellBtn.position
        sellLabel.fontColor = UIColor.black
        adjustLabelFontSizeToFitRect(labelNode: sellLabel, rect: sellBtn.frame)
        
        popup.addChild(sellLabel)
        popup.addChild(upgradeLabel)
        popup.addChild(sellBtn)
        popup.addChild(image)
        popup.addChild(upgradeBtn)
        popup.name = "Upgrade Popup"
    }

    
    private func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
        let offset: CGFloat = 20
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min((rect.width - offset) / labelNode.frame.width, (rect.height - offset) / labelNode.frame.height)
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
        // Optionally move the SKLabelNode to the center of the rectangle.
        labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
    }
}
