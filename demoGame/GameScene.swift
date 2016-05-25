//
//  GameScene.swift
//  demoGame
//
//  Created by nju on 16/5/1.
//  Copyright (c) 2016年 nju. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var gridWidth = 200
    var gridHeight = 200
    
    let blockWidth = 40
    let blockHeight = 40
    let spaceBetweenBlock = 12
    
    var sign = 1
    
    var isTouched = false
    var backgroundNode:SKSpriteNode = SKSpriteNode()
    var gBoard = gameBoard()
    var action_list = Array<Location>()
    var node_list = Array<SKNode>()
    
    override init(size: CGSize) {
        gBoard = gameBoard()
        super.init(size: size)
        
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        var x_margin = 0.0
        var y_margin = 0.0
        
        x_margin = Double(self.size.width) - Double(gBoard.numCols * blockWidth)
        x_margin = x_margin - Double((gBoard.numCols+1)*spaceBetweenBlock)
        x_margin = x_margin / 2
        y_margin = Double(self.size.height) - Double(gBoard.numRows * blockHeight)
        y_margin = y_margin - Double((gBoard.numRows+1)*spaceBetweenBlock)
        y_margin = y_margin / 2
        
        
        
        backgroundNode = SKSpriteNode()
        backgroundNode.size = CGSize(width: frame.size.width * 0.9, height: frame.size.height * 0.9)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = 0;
        backgroundNode.position = CGPoint(x: 20, y: 120)
        backgroundNode.color = UIColor(red:0.95,green:0.69,blue:0.41,alpha:0.5)
        backgroundNode.name = "background"
        self.addChild(backgroundNode)
        
        gBoard.init_board()
        gBoard.set_board("level1")
        
        for y in 0...(gBoard.numRows-1){
            for x in 0...(gBoard.numCols-1){
                let tile = SKSpriteNode()
                let x_temp = x * blockWidth + (x + 1) * spaceBetweenBlock
                let y_temp = y * blockHeight + (y + 1) * spaceBetweenBlock
                tile.position = CGPoint(x: x_margin + Double(x_temp),y: y_margin + Double(y_temp))
                //tile.anchorPoint = CGPoint(x:0, y:0)
                tile.size = CGSize(width: blockWidth,height: blockHeight)
                tile.zPosition = 0
                
                backgroundNode.addChild(tile)
                let gameValue = gBoard.get_value(x,y:y)
                if(gameValue == 1 || gameValue == 2){
                    tile.name = "node:\(x),\(y)"
                }
                if(gameValue == 3 || gameValue == 4){
                    tile.name = "startnode:\(x),\(y)"
                }
                tile.color = get_color(gameValue)
                
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let node = self.nodeAtPoint(location)
            let name = node.name
            if (name?.componentsSeparatedByString("node").count > 1){
                if(name?.componentsSeparatedByString("start").count > 1){
                    print("start")
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
                    
                    var x = Int(subString2[0])
                    var y = Int(subString2[1])
                    
                    var n = Location()
                    n.x = x!
                    n.y = y!
                    
                    if(action_list.count > 0 && (abs(action_list[action_list.count-1].x - x!) > 1||abs(action_list[action_list.count-1].y - y!) > 1)){
                        return
                    }
                    
                    if(action_list.count == 0){
                        
                        action_list.append(n)
                        node_list.append(node)
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
                                print(x! ,y!)
                                action_list.removeLast()
                                node_list.removeLast()
                                
                            }
                            else{
                                action_list.append(n)
                                node_list.append(node)
                            }
                        }
                        else{
                            action_list.append(n)
                            node_list.append(node)
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
                    gBoard.board[action_list[index].x % gBoard.numRows + action_list[index].y * gBoard.numCols] = change_value(value)
                }
            }
            let value = gBoard.get_value(action_list[0].x, y: action_list[0].y)
            node_list[0].runAction(get_start_action(value))
            node_list[0].name = "node:\(action_list[0].x),\(action_list[0].y)"
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
            let actions: [SKAction] = [SKAction.waitForDuration(2.0),SKAction.runBlock({
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
            let actions: [SKAction] = [SKAction.waitForDuration(2.0),SKAction.runBlock({
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
    
    func get_color (v:Int) -> UIColor{
        switch v{
        case 1:return UIColor(red:0,green:0,blue:0,alpha:0.5)
        case 2:return UIColor(red:1,green:1,blue:1,alpha:0.5)
        case 3:return UIColor(red:1,green:0,blue:0,alpha:0.5)
        case 4:return UIColor(red:0,green:1,blue:0,alpha:0.5)
        default:return UIColor(red:0.95,green:0.69,blue:0.41,alpha:0.5)
        }
    }
    
    func get_action (v:Int) -> SKAction{
        switch v{
        case 1:return SKAction.colorizeWithColor(UIColor(red:1,green:1,blue:1,alpha:0.5), colorBlendFactor: 0, duration: 0)
        case 2:return SKAction.colorizeWithColor(UIColor(red:0,green:0,blue:0,alpha:0.5), colorBlendFactor: 0, duration: 0)
        case 3:return SKAction.colorizeWithColor(UIColor(red:0,green:1,blue:0,alpha:0.5), colorBlendFactor: 0, duration: 0)
        case 4:return SKAction.colorizeWithColor(UIColor(red:1,green:0,blue:0,alpha:0.5), colorBlendFactor: 0, duration: 0)
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
        case 3:return SKAction.colorizeWithColor(UIColor(red:1,green:1,blue:1,alpha:0.5), colorBlendFactor: 0, duration: 0)
        case 4:return SKAction.colorizeWithColor(UIColor(red:0,green:0,blue:0,alpha:0.5), colorBlendFactor: 0, duration: 0)
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
}
