//
//  gameBoard.swift
//  demoGame
//
//  Created by nju on 16/5/1.
//  Copyright © 2016年 nju. All rights reserved.
//

import Foundation
import UIKit

enum GameStatus{
    case Won, Lose, Playing
}

class gameBoard{
    let numRows = 4;
    let numCols = 4;
    var board = Array<Int>()
    var is_changed = Array<Int>()
    
    init(){
        board = Array(count: 16,repeatedValue: 0)
        is_changed = Array(count: 16,repeatedValue: 0)
    }
    
    func init_board(){
        for y in 0...(numRows-1) {
            for x in 0...(numCols-1){
                print(x % numRows + y * numCols)
                board[x % numRows + y * numCols] = 1
                is_changed[x % numRows + y * numCols] = 0
            }
        }
    }
    
    func set_board(filename:String){
        var sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        print(sp[0])
        print(sp.count)
        if sp.count > 0{
            var url = NSURL(fileURLWithPath: "\(sp[0])/\(filename).txt")
            var data = NSMutableData()
            
            data.writeToFile(url.path!, atomically: true)
            
            var data1 = NSData(contentsOfFile: url.path!)
            
        }
        board[3] = 3
        board[7] = 3
    }
    
    func get_value(x:Int,y:Int) -> Int{
        let index = x % numRows + y * numCols
        return board[index]
    }
    
    func judge_game () -> Bool{
        var num = 0
        for y in 0...(numRows-1) {
            for x in 0...(numCols-1){
                if(x % numRows + y * numCols + 1 >= numCols * numRows){break;}
                if(board[x % numRows + y * numCols] == board[x % numRows + y * numCols + 1]){
                    num = num + 1
                }
            }
        }
        print(num)
        if(num == numCols * numRows - 1){
            return true
        }
        else{
            return false
        }
    }
    
    func has_no_start ()->Bool{
        for y in 0...(numRows-1) {
            for x in 0...(numCols-1){
                if(board[x % numRows + y * numCols] == 3 || board[x % numRows + y * numCols] == 4){
                    return true
                }
            }
        }
        return false
    }
}