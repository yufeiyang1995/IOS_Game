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
    var bgMusicPlayer = AVAudioPlayer()
    
    func BackgroundMusic(){
        var bgMusicURL:NSURL =  NSBundle.mainBundle().URLForResource("bgm", withExtension: "mp3")!
        //根据背景音乐地址生成播放器

        do{
            try bgMusicPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL)
        }
        catch{
            
        }
        //设置为循环播放
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        
        if !bgMusicPlayer.playing{
        //播放音乐
            bgMusicPlayer.play()
        }
    }
    
    func stopBgm(){
        bgMusicPlayer.stop()
    }
    
    func platHit(){
        self.runAction(hitAct)
    }
}
