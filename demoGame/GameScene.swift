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
    let spaceBetweenBlock = 8
    
    var isTouched = false
    var backgroundNode:SKSpriteNode = SKSpriteNode()
    var gBoard = gameBoard()
    var action_list = Array<Location>()
    var node_list = Array<SKNode>()
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.whiteColor()
        
        backgroundNode = SKSpriteNode()
        backgroundNode.size = CGSize(width: frame.size.width * 0.4, height: frame.size.width * 0.4)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -1;
        backgroundNode.position = CGPoint(x: 300, y: 150)
        backgroundNode.color = UIColor(red:0.95,green:0.69,blue:0.41,alpha:0.5)
        backgroundNode.name = "background"
        self.addChild(backgroundNode)
        
        gBoard.init_board()
        gBoard.set_board("level1")
        
        for y in 0...(gBoard.numRows-1){
            for x in 0...(gBoard.numCols-1){
                let tile = SKSpriteNode()
                tile.position = CGPoint(x: x * blockWidth + (x + 1) * spaceBetweenBlock,y: y * blockHeight + (y + 1) * spaceBetweenBlock)
                tile.anchorPoint = CGPoint(x:0, y:0)
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
            print("Success!")
        }
        else if(gBoard.has_no_start() == false){
            print("Failed")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
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
