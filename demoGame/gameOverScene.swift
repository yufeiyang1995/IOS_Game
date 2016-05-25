//
//  gameOverScene.swift
//  demoGame
//
//  Created by nju on 16/5/25.
//  Copyright © 2016年 nju. All rights reserved.
//

import SpriteKit

class gameOverScene : SKScene{
    
    convenience init(size: CGSize, won: Bool) {
        self.init(size: size)
        self.backgroundColor = SKColor(red:1.0, green:1.0 ,blue:1.0 ,alpha:0.5)
        self.setupMsgLabel(won)
        self.directorAction()
    }
    
    func setupMsgLabel(won: Bool){
        var msg: String = won ? "You Win!" : "You Lose :["
        
        var msgLabel = SKLabelNode(fontNamed: "Chalkduster")
        msgLabel.text = msg
        msgLabel.fontSize = 60
        msgLabel.fontColor = SKColor(red:1.0, green:0.0 ,blue:0.0 ,alpha:0.5)
        msgLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(msgLabel)
    }
    
    func directorAction(){
        let actions: [SKAction] = [SKAction.waitForDuration(2.0),SKAction.runBlock({
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameScene = GameScene(size:self.size)
            self.view?.presentScene(gameScene, transition: reveal)
        })]
        let sequence = SKAction.sequence(actions)
        self.runAction(sequence)
    }
}

