//
//  startGameScene.swift
//  demoGame
//
//  Created by nju on 16/6/5.
//  Copyright © 2016年 nju. All rights reserved.
//

import SpriteKit

class startGameScene: SKScene{
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
        
        let msg: String = "The Same World"
        let msgLabel = SKLabelNode(fontNamed: "Chalkduster")
        msgLabel.text = msg
        msgLabel.fontSize = 32
        msgLabel.fontColor = SKColor(red:0.0, green:0.0 ,blue:0.0 ,alpha:0.5)
        msgLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 90)
        self.addChild(msgLabel)

        
        let nextTexture = SKTexture(imageNamed:"start")
        let node = SKSpriteNode(texture: nextTexture)
        node.name = "start"
        node.position = CGPointMake(self.size.width/2, self.size.height * 0.25 + 20)
        // node.size = CGSize(width: self.size.width/4 ,height: self.size.width/8)
        node.zPosition = 0
        node.setScale(0.45)
        //node.color = UIColor(red: 1.0,green: 0.0,blue: 0.0,alpha: 0.5)
        self.addChild(node)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            print(node.name)
            if(node.name == "start"){
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