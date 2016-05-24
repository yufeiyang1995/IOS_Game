//
//  Card.swift
//  demoGame
//
//  Created by nju on 16/5/1.
//  Copyright © 2016年 nju. All rights reserved.
//

import Foundation
import SpriteKit

class Card : SKSpriteNode{
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not support")
    }
    
    init(imageName: String){
        let cardTexture = SKTexture(imageNamed: imageName)
        NSLog("%@", imageName)
        super.init(texture: cardTexture, color: UIColor(red: 55/255, green: 186/255, blue: 89/255, alpha: 0.5), size: cardTexture.size())
    }
}