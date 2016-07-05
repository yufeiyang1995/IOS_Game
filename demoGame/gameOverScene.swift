//
//  gameOverScene.swift
//  demoGame
//
//  Created by nju on 16/5/25.
//  Copyright © 2016年 nju. All rights reserved.
//

import SpriteKit

class gameOverScene : SKScene{
    var sign = true
    
    convenience init(size: CGSize, won: Bool) {
        self.init(size: size)
        var backgroundNode:SKSpriteNode = SKSpriteNode()
        let nodeTexture = SKTexture(imageNamed: "beijing")
        backgroundNode = SKSpriteNode(texture: nodeTexture)
        backgroundNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = 0;
        backgroundNode.position = CGPoint(x: 0, y: 0)
        
        backgroundNode.name = "background"
        self.addChild(backgroundNode)
        
        self.setupMsgLabel(won)
        
        if won && level.l != 6{
            sign = true
            let nextTexture = SKTexture(imageNamed:"kaishi2")
            let node = SKSpriteNode(texture: nextTexture)
            node.name = "next"
            node.position = CGPointMake(self.size.width/2, self.size.height * 0.25 + 10)
           // node.size = CGSize(width: self.size.width/4 ,height: self.size.width/8)
            node.zPosition = 0
            node.setScale(0.25)
            //node.color = UIColor(red: 1.0,green: 0.0,blue: 0.0,alpha: 0.5)
            self.addChild(node)
        }
        else if won && level.l == 6{
            let nextTexture = SKTexture(imageNamed:"caidan")
            let node = SKSpriteNode(texture: nextTexture)
            node.name = "menu"
            node.position = CGPointMake(self.size.width/2, self.size.height * 0.25 + 10)
            // node.size = CGSize(width: self.size.width/4 ,height: self.size.width/8)
            node.zPosition = 0
            node.setScale(0.35)
            //node.color = UIColor(red: 1.0,green: 0.0,blue: 0.0,alpha: 0.5)
            self.addChild(node)
        }
        else{
            sign = false
            let nextTexture = SKTexture(imageNamed:"restart")
            let node = SKSpriteNode(texture: nextTexture)
            node.name = "replay"
            node.position = CGPointMake(self.size.width/2, self.size.height * 0.25 + 10)
            node.setScale(0.7)
           // node.size = CGSize(width: self.size.width/4 ,height: self.size.width/8)
            node.zPosition = 0
           // node.color = UIColor(red: 0.0,green: 1.0,blue: 0.0,alpha: 0.5)
            self.addChild(node)
        }
        //self.directorAction(won)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            print(node.name)
            if(node.name == "next"){
                self.directorAction(sign)
            }
            if(node.name == "replay"){
                self.directorAction(sign)
            }
            if(node.name == "menu"){
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(1.0),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = selectGameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
        }
        
    }
    
    func setupMsgLabel(won: Bool){
        var msg: String = won ? "You Win!" : "You Lose :["
        if level.l == 6 && won{
            msg = "You Success!"
            var msgLabel = SKLabelNode(fontNamed: "Chalkduster")
            msgLabel.text = msg
            msgLabel.fontSize = 35
            msgLabel.fontColor = SKColor(red:0.0, green:0.0 ,blue:0.0 ,alpha:0.5)
            msgLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 30)
            self.addChild(msgLabel)
        }
        else{
            var msgLabel = SKLabelNode(fontNamed: "Chalkduster")
            msgLabel.text = msg
            msgLabel.fontSize = 45
            msgLabel.fontColor = SKColor(red:0.0, green:0.0 ,blue:0.0 ,alpha:0.5)
            msgLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 50)
            self.addChild(msgLabel)
        }
    }
    
    func directorAction(won: Bool){
        if won{
            level.level_up()
        }
        self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
        let actions: [SKAction] = [SKAction.waitForDuration(1.0),SKAction.runBlock({
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameScene = GameScene(size:self.size)
            self.view?.presentScene(gameScene, transition: reveal)
        })]
        let sequence = SKAction.sequence(actions)
        self.runAction(sequence)
    }
}

