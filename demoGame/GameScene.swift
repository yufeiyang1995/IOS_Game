//
//  GameScene.swift
//  demoGame
//
//  Created by nju on 16/5/1.
//  Copyright (c) 2016年 nju. All rights reserved.
//

import SpriteKit
import AudioToolbox

class GameScene: SKScene {
    var gridWidth = 200
    var gridHeight = 200
    
    let blockWidth = 40
    let blockHeight = 40
    let spaceBetweenBlock = 25
    
    var sign = 1
    
    var isTouched = false
    var backgroundNode:SKSpriteNode = SKSpriteNode()
    var gBoard = gameBoard()
    var action_list = Array<Location>()
    var node_list = Array<SKNode>()
    
    enum Level: Int{
        case One = 1,Two,Three,Four,Five,Six
        mutating func nextLevel(){
            switch self{
            case .One:self = .Two
            case .Two:self = .Three
            case .Three:self = .Four
            case .Four:self = .Five
            case .Five:self = .Six
            default:self = .One
            }
        }
    }
    var gameLevel:Level = .One
    
    override init(size: CGSize) {
        gBoard = gameBoard()
        super.init(size: size)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        print(gameLevel.rawValue)
        gBoard.init_board()
        gBoard.set_board()
        var x_margin = 0.0
        var y_margin = 0.0
        
        print(frame.size.width)
        x_margin = Double(frame.size.width) - Double(gBoard.numCols * blockWidth)
        print(x_margin);
        x_margin = x_margin - Double((gBoard.numCols+1)*spaceBetweenBlock)
        print(x_margin);
        x_margin = x_margin / 2
        print(x_margin);
        y_margin = Double(frame.size.height) - Double(gBoard.numRows * blockHeight)
        y_margin = y_margin - Double((gBoard.numRows+1)*spaceBetweenBlock)
        y_margin = y_margin / 2
        
        
        let nodeTexture = SKTexture(imageNamed: "beijing")
        backgroundNode = SKSpriteNode(texture: nodeTexture)
        backgroundNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = 0;
        backgroundNode.position = CGPoint(x: 0, y: 0)
        
        backgroundNode.name = "background"
        self.addChild(backgroundNode)
        
        
        for y in 0...(gBoard.numRows-1){
            for x in 0...(gBoard.numCols-1){
                let gameValue = gBoard.get_value(x,y:y)
                if(gameValue > 0){
                    let nodeName = get_name(gameValue)
                    let nodeTexture = SKTexture(imageNamed: nodeName)
                
                    let tile = SKSpriteNode(texture: nodeTexture)
                    let x_temp = x * blockWidth + (x + 1) * spaceBetweenBlock
                    let y_temp = y * blockHeight + (y + 1) * spaceBetweenBlock
                    tile.position = CGPoint(x: x_margin + Double(x_temp) + 20,y: y_margin + Double(y_temp) + 20)
                //tile.anchorPoint = CGPoint(x:0, y:0)
                    tile.size = CGSize(width: blockWidth,height: blockHeight)
                    tile.setScale(1.3)
                    tile.zPosition = 0.5
                
                    if(gameValue == 1 || gameValue == 2){
                        tile.name = "node:\(x),\(y)"
                    }
                    if(gameValue == 3 || gameValue == 4){
                        tile.name = "startnode:\(x),\(y)"
                    }
                
                    backgroundNode.addChild(tile)
               // tile.color = get_color(gameValue)
                }
                
            }
        }
        
        let replayTexture = SKTexture(imageNamed: "restart")
        let node = SKSpriteNode(texture: replayTexture)
        node.name = "replay"
        node.setScale(0.5)
        node.zPosition = 0.5
        node.position = CGPoint(x: 30,y: self.size.height-30)
        backgroundNode.addChild(node)
        
        let menuTexture = SKTexture(imageNamed: "caidan")
        let node1 = SKSpriteNode(texture: menuTexture)
        node1.name = "menu"
        node1.setScale(0.25)
        node1.zPosition = 0.5
        node1.position = CGPoint(x: self.size.width-30,y: self.size.height-30)
        backgroundNode.addChild(node1)
        
        let msg: String = selectLevel(level.l)
        let msgLabel = SKLabelNode(fontNamed: "Chalkduster")
        msgLabel.text = msg
        msgLabel.fontSize = 40
        msgLabel.fontColor = SKColor(red:0.0, green:0.0 ,blue:0.0 ,alpha:0.5)
        msgLabel.position = CGPointMake(self.size.width/2, self.size.height-50)
        self.addChild(msgLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let node = self.nodeAtPoint(location)
            let name = node.name
            if(name == "replay"){
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = GameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
                
            }
            if(name == "menu"){
                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let gameScene = selectGameScene(size:self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                })]
                let sequence = SKAction.sequence(actions)
                self.runAction(sequence)
            }
            if (name?.componentsSeparatedByString("node").count > 1){
                if(name?.componentsSeparatedByString("start").count > 1){
                    print("start")
                    let wiggleIn = SKAction.scaleTo(1.5, duration: 0.1)
                    //let wiggleOut = SKAction.scaleTo(2.2, duration: 0.1)
                    node.runAction(wiggleIn)
                    
                    isTouched = true
                    let subString1 = name?.componentsSeparatedByString(":")
                    let subString2 = subString1![1].componentsSeparatedByString(",")
                    
                    var x = Int(subString2[0])
                    var y = Int(subString2[1])
                    
                    var n = Location()
                    n.x = x!
                    n.y = y!
                    action_list.append(n)
                    node_list.append(node)
                    
                    //var soundID = SystemSoundID(kSystemSoundID_Vibrate)
                    
                    self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if isTouched{
                var location:CGPoint! = touch.locationInNode(self)
                var node = self.nodeAtPoint(location)
                let name = node.name
                if (name?.componentsSeparatedByString("node").count > 1){
                    let subString1 = name?.componentsSeparatedByString(":")
                    let subString2 = subString1![1].componentsSeparatedByString(",")
                    let wiggleIn = SKAction.scaleTo(1.5, duration: 0.1)
                   // let wiggleOut = SKAction.scaleTo(2.2, duration: 0.1)
                    
                    
                    var x = Int(subString2[0])
                    var y = Int(subString2[1])
                    
                    var n = Location()
                    n.x = x!
                    n.y = y!
                    
                    if(action_list.count > 0 && (abs(action_list[action_list.count-1].x - x!) > 1||abs(action_list[action_list.count-1].y - y!) > 1)){
                        return
                    }
                    if(action_list.count > 0 && abs(action_list[action_list.count-1].x - x!) == 1&&abs(action_list[action_list.count-1].y - y!) == 1){
                        return;
                    }

                    
                    if(action_list.count == 0){
                        node.runAction(wiggleIn)
                        action_list.append(n)
                        node_list.append(node)
                        self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                        //let value = gBoard.get_value(x!,y: y!)
                        
                    }
                    else{
                        if(x == action_list[action_list.count-1].x && y == action_list[action_list.count-1].y){
                            print(subString2[0] + "," + subString2[1])
                        }
                        else if(action_list.count >= 2){
                            
                            if(action_list[action_list.count-2].x == x! && action_list[action_list.count-2].y == y!){
                                print("test")
                                x = action_list[action_list.count - 1].x
                                y = action_list[action_list.count - 1].y
                                let wiggleout = SKAction.scaleTo(1.3, duration: 0.1)
                                node_list[action_list.count - 1].runAction(wiggleout)
                                print(x! ,y!)
                                action_list.removeLast()
                                node_list.removeLast()
                            }
                            else{
                                node.runAction(wiggleIn)
                                action_list.append(n)
                                node_list.append(node)
                                self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                            }
                        }
                        else{
                            node.runAction(wiggleIn)
                            action_list.append(n)
                            node_list.append(node)
                            self.runAction(SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false))
                            //let value = gBoard.get_value(x!,y: y!)
                            //node.runAction(get_action(value))
                            //gBoard.board[x! % gBoard.numRows + y! * gBoard.numCols] = change_value(value)
                        }
                    }
                    
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(action_list)
        if(action_list.count > 0){
            for index in 0...(action_list.count-1){
                if(index != 0){
                    let value = gBoard.get_value(action_list[index].x, y: action_list[index].y)
                    node_list[index].runAction(get_action(value))
                    let wiggleout = SKAction.scaleTo(1.3, duration: 0.1)
                    node_list[index].runAction(wiggleout)
                    gBoard.board[action_list[index].x % gBoard.numRows + action_list[index].y * gBoard.numCols] = change_value(value)
                }
            }
            let value = gBoard.get_value(action_list[0].x, y: action_list[0].y)
            node_list[0].runAction(get_start_action(value))
            node_list[0].name = "node:\(action_list[0].x),\(action_list[0].y)"
            let wiggleout = SKAction.scaleTo(1.3, duration: 0.1)
            node_list[0].runAction(wiggleout)
            gBoard.board[action_list[0].x % gBoard.numRows + action_list[0].y * gBoard.numCols] = change_start_value(value)
            
            node_list.removeAll()
            action_list.removeAll()
        }
        isTouched = false
        if(gBoard.judge_game() == true){
            sign = 2
            /*var reveal = SKTransition.flipHorizontalWithDuration(0.5)
            var gameScene = gameOverScene(size: self.size,won: true)
            self.view?.presentScene(gameScene, transition: reveal)*/
            print("Success!")
        }
        else if(gBoard.has_no_start() == false){
            sign = 3
            print("Failed")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(sign == 2){
            let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameScene = gameOverScene(size: self.size,won: true)
                self.view?.presentScene(gameScene, transition: reveal)
            })]
            let sequence = SKAction.sequence(actions)
            self.runAction(sequence)
            
        }
        else if(sign == 3){
           /* var reveal = SKTransition.flipHorizontalWithDuration(0.5)
            var gameScene = gameOverScene(size: self.size,won: false)
            self.view?.presentScene(gameScene, transition: reveal)
            */
            let actions: [SKAction] = [SKAction.waitForDuration(0.5),SKAction.runBlock({
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameScene = gameOverScene(size: self.size,won: false)
                self.view?.presentScene(gameScene, transition: reveal)
            })]
            var sequence = SKAction.sequence(actions)
            self.runAction(sequence)
        }
    }
    
    override func didFinishUpdate() {
        
    }
    
    func get_name (v:Int) -> String{
        switch v{
        case 1:return "black"
        case 2:return "white"
        case 3:return "blackStart"
        case 4:return "whiteStart"
        default:return ""
        }
    }
    
    func get_action (v:Int) -> SKAction{
        print(v)
        switch v{
        case 1:
            let changePic = SKAction.animateWithTextures([SKTexture(imageNamed: "white")], timePerFrame: 0)
            let firstFlip = SKAction.scaleXTo(0.0, duration: 0.2)
            let secondFlip = SKAction.scaleXTo(1.3, duration: 0.2)
            let sequence = SKAction.sequence([firstFlip,changePic,secondFlip])
            return sequence
        case 2:let changePic = SKAction.animateWithTextures([SKTexture(imageNamed: "black")], timePerFrame: 0)
            let firstFlip = SKAction.scaleXTo(0.0, duration: 0.2)
            let secondFlip = SKAction.scaleXTo(1.3, duration: 0.2)
            let sequence = SKAction.sequence([firstFlip,changePic,secondFlip])
            return sequence
        case 3:let changePic = SKAction.animateWithTextures([SKTexture(imageNamed: "whiteStart")], timePerFrame: 0)
            let firstFlip = SKAction.scaleXTo(0.0, duration: 0.2)
            let secondFlip = SKAction.scaleXTo(1.3, duration: 0.2)
            let sequence = SKAction.sequence([firstFlip,changePic,secondFlip])
            return sequence
        case 4:let changePic = SKAction.animateWithTextures([SKTexture(imageNamed: "blackStart")], timePerFrame: 0)
            let firstFlip = SKAction.scaleXTo(0.0, duration: 0.2)
            let secondFlip = SKAction.scaleXTo(1.3, duration: 0.2)
            let sequence = SKAction.sequence([firstFlip,changePic,secondFlip])
            return sequence
        default:return SKAction.colorizeWithColor(UIColor(red:0,green:0,blue:0,alpha:0.5), colorBlendFactor: 0, duration: 0)
        }
    }
    
    
    func change_value(v:Int) -> Int{
        switch v {
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 4
        case 4:
            return 3
        default:
            return 0
        }
    }
    
    func get_start_action(v:Int) -> SKAction{
        switch v{
        case 3:let changePic = SKAction.animateWithTextures([SKTexture(imageNamed: "white")], timePerFrame: 0)
        let firstFlip = SKAction.scaleXTo(0.0, duration: 0.2)
        let secondFlip = SKAction.scaleXTo(1.3, duration: 0.2)
        let sequence = SKAction.sequence([firstFlip,changePic,secondFlip])
        return sequence
        case 4:let changePic = SKAction.animateWithTextures([SKTexture(imageNamed: "black")], timePerFrame: 0)
        let firstFlip = SKAction.scaleXTo(0.0, duration: 0.2)
        let secondFlip = SKAction.scaleXTo(1.3, duration: 0.2)
        let sequence = SKAction.sequence([firstFlip,changePic,secondFlip])
        return sequence
        default:return SKAction.colorizeWithColor(UIColor(red:0,green:0,blue:0,alpha:0.5), colorBlendFactor: 0, duration: 0)
        }
    }
    
    func change_start_value(v:Int) -> Int{
        switch v{
        case 3:return 2;
        case 4:return 1;
        default:return 0;
        }
    }
    
    func selectLevel(l:Int) -> String{
        switch l{
        case 1:return "1-1"
        case 2:return "1-2"
        case 3:return "1-3"
        case 4:return "1-4"
        case 5:return "1-5"
        case 6:return "1-6"
        default:return ""
        }
    }
}
