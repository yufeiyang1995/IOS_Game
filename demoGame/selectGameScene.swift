//
//  selectGameScene.swift
//  demoGame
//
//  Created by nju on 16/7/4.
//  Copyright © 2016年 nju. All rights reserved.
//

import SpriteKit

class selectGameScene: SKScene{
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        var backgroundNode:SKSpriteNode = SKSpriteNode()
        let nodeTexture = SKTexture(imageNamed: "beijing")
        backgroundNode = SKSpriteNode(texture: nodeTexture)
        backgroundNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = 0;
        backgroundNode.position = CGPoint(x: 0, y: 0)
        
        backgroundNode.name = "background"
        self.addChild(backgroundNode)
        
        let msg: String = "Levels"
        let msgLabel = SKLabelNode(fontNamed: "Chalkduster")
        msgLabel.text = msg
        msgLabel.fontSize = 40
        msgLabel.fontColor = SKColor(red:0.0, green:0.0 ,blue:0.0 ,alpha:0.5)
        msgLabel.position = CGPointMake(self.size.width/2, self.size.height/5 * 4)
        self.addChild(msgLabel)
        
        for y in 0...1{
            for x in 0...2{
                let nextTexture = SKTexture(imageNamed:"\(y+1).\(x+1)")
                let node = SKSpriteNode(texture: nextTexture)
                node.name = "level:\(x + y * 3)"
                node.position = CGPointMake(self.size.width/3 * CGFloat(x) + self.size.width/6, self.size.height * 0.25 * CGFloat(2 - y) + 30)
                // node.size = CGSize(width: self.size.width/4 ,height: self.size.width/8)
                node.zPosition = 0
                node.setScale(0.55)
                //node.color = UIColor(red: 1.0,green: 0.0,blue: 0.0,alpha: 0.5)
                self.addChild(node)
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            print(node.name)
            if(node.name == "level:0"){
                level.level_select(1)
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
            else if(node.name == "level:1"){
                level.level_select(2)
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
            else if(node.name == "level:2"){
                level.level_select(3)
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
            else if(node.name == "level:3"){
                level.level_select(4)
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
            else if(node.name == "level:4"){
                level.level_select(5)
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
            else if(node.name == "level:5"){
                level.level_select(6)
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
        }
        
    }

}