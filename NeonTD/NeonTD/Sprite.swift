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
    
    
    /// Initializer for a basic square Sprite.
    ///
    /// - Parameters:
    ///   - color: Color of the sprite.
    ///   - size: Size of the sprite.
    ///   - pos: Position of the sprite.
    init(color: UIColor, size: CGSize, pos: CGPoint) {
        sprite.color = color
        sprite.size = size
        sprite.position = pos
    }
    
    
    /// Initializer for a Sprite with an image.
    ///
    /// - Parameters:
    ///   - imageName: Name of the image.
    ///   - size: Size of the sprite.
    ///   - pos: Position of the sprite
    init(imageName: String, size: CGSize, pos: CGPoint) {
        let sprite = SKSpriteNode(imageNamed: imageName)
        self.sprite = sprite
        sprite.size = size
        //sprite.texture = SKTexture(imageNamed: imageName)
        sprite.position = pos
    }
    
    
    /// Change the color of the sprite
    ///
    /// - Parameter color: Desired color for the sprite
    func setColor(color: UIColor) {
        sprite.color = color;
    }
    
    
    /// Change the sprite's texture
    ///
    /// - Parameter imageName: Name of the image file
    func setImage(imageName: String) {
        sprite.texture = SKTexture(imageNamed: imageName)
    }
    
    /// Clockwise rotation using degrees
    ///
    /// - Parameter degrees: double value for rotation
    func rotate(degrees: Double) {
        let rotation = (degrees * .pi) / 180.0
        sprite.zRotation = CGFloat(rotation)
    }
    /// Clockwise rotation using radians
    ///
    /// - Parameter radians: double value for rotation
    func rotate(radians: Double) {
        let rotation = radians
        sprite.zRotation = CGFloat(rotation)
    }
}
