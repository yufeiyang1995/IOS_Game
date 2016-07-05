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
    var numRows = 4;
    var numCols = 4;
    var board = Array<Int>()
    var is_changed = Array<Int>()
    
    init(){
        board = Array(count: 16,repeatedValue: 0)
        is_changed = Array(count: 16,repeatedValue: 0)
    }
    
    func init_board(){
        switch level.l {
        case 1:
            numRows = 5
            numCols = 4
            board = Array(count: 20,repeatedValue: 0)
            is_changed = Array(count: 20,repeatedValue: 0)
            break
        case 2:
            numRows = 5
            numCols = 4
            board = Array(count: 25,repeatedValue: 0)
            is_changed = Array(count: 25,repeatedValue: 0)
        case 3:
            numRows = 6
            numCols = 5
            board = Array(count: 36,repeatedValue: 0)
            is_changed = Array(count: 36,repeatedValue: 0)
        case 4:
            numRows = 6
            numCols = 5
            board = Array(count: 36,repeatedValue: 0)
            is_changed = Array(count: 36,repeatedValue: 0)
        case 5:
            numRows = 6
            numCols = 5
            board = Array(count: 36,repeatedValue: 0)
            is_changed = Array(count: 36,repeatedValue: 0)
        case 6:
            numRows = 6
            numCols = 5
            board = Array(count: 36,repeatedValue: 0)
            is_changed = Array(count: 36,repeatedValue: 0)
        default:numCols = 4
            numRows = 4
            
        }
        for y in 0...(numRows-1) {
            for x in 0...(numCols-1){
                print(x % numRows + y * numCols)
                board[x % numRows + y * numCols] = 1
                is_changed[x % numRows + y * numCols] = 0
            }
        }
    }
    
    func set_board(){
        switch level.l{
        case 1:
            board[2] = 2
            board[6] = 2
            board[8] = 2
            board[9] = 2
            board[11] = 4
            board[14] = 2
            board[18] = 4
            break
        case 2:
            board[0] = 3
            board[3] = 3
            for x in 4...7{
                board[x] = 2
            }
            for x in 12...15{
                board[x] = 2
            }
            break
        case 3:
            for x in 0...4{
                board[x] = 2
            }
            board[5] = 2
            board[9] = 2
            board[10] = 2
            board[12] = 2
            board[14] = 2
            board[16] = 2
            board[18] = 2
            board[19] = 3
            board[20] = 2
            board[22] = 2
            board[24] = 2
            board[25] = 2
            board[27] = 2
            board[29] = 2
            board[26] = 3
        case 4:
            board[0] = 0
            board[1] = 0
            board[3] = 3
            board[4] = 2
            board[5] = 0
            board[6] = 0
            board[8] = 2
            board[9] = 2
            board[13] = 2
            board[16] = 2
            board[20] = 2
            board[21] = 2
            board[23] = 0
            board[24] = 0
            board[25] = 4
            board[28] = 0
            board[29] = 0
        case 5:
            board[0] = 3
            board[4] = 2
            board[5] = 2
            board[6] = 2
            board[8] = 2
            board[9] = 2
            board[10] = 0
            board[11] = 2
            board[13] = 2
            board[14] = 0
            board[15] = 0
            board[16] = 2
            board[18] = 2
            board[19] = 0
            board[20] = 2
            board[21] = 2
            board[23] = 2
            board[24] = 2
            board[25] = 2
            board[28] = 3
            board[29] = 2
        case 6:
            board[0] = 2
            board[2] = 2
            board[4] = 2
            board[5] = 0
            board[9] = 0
            board[11] = 2
            board[13] = 2
            board[20] = 0
            board[24] = 0
            board[25] = 4
            board[26] = 2
            board[27] = 4
            board[28] = 2
            board[29] = 4
        default:return
        }
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
                if((board[x % numRows + y * numCols] == board[x % numRows + y * numCols + 1]) ||
                    (board[x % numRows + y * numCols] == 0 || board[x % numRows + y * numCols + 1] == 0)){
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