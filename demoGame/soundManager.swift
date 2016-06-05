//
//  soundManager.swift
//  demoGame
//
//  Created by nju on 16/6/5.
//  Copyright © 2016年 nju. All rights reserved.
//


import SpriteKit
import AVFoundation

class soundManager: SKNode{
    let hitAct = SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false)
    
    func BackgroundMusic(){
        
    }
    
    func platHit(){
        self.runAction(hitAct)
    }
}
