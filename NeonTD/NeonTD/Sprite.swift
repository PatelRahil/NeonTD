//
//  Sprite.swift
//  NeonTD
//
//  Created by Rahil Patel on 12/10/18.
//  Copyright © 2018 RahilPatel. All rights reserved.
//

import SpriteKit

class Sprite {
    var sprite = SKSpriteNode()
    
    // Testing (pre-texture creation init)
    init(color: UIColor, size: CGSize, pos: CGPoint) {
        sprite.color = color
        sprite.size = size
        sprite.position = pos
    }
    init(imageName: String, size: CGSize, pos: CGPoint) {
        let sprite = SKSpriteNode(imageNamed: imageName)
        self.sprite = sprite
        sprite.size = size
        //sprite.texture = SKTexture(imageNamed: imageName)
        sprite.position = pos
    }
    func setColor(color: UIColor) {
        sprite.color = color;
    }
    func setImage(imageName: String) {
        sprite.texture = SKTexture(imageNamed: imageName)
    }
    
    // Clockwise rotation by given degrees
    func rotate(degrees: Double) {
        let rotation = (degrees * .pi) / 180.0
        sprite.zRotation = CGFloat(rotation)
    }
    // Clockwise rotation by given radian
    func rotate(radians: Double) {
        let rotation = radians
        sprite.zRotation = CGFloat(rotation)
    }
}
