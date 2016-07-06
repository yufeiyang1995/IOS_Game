//
//  startViewontroller.swift
//  demoGame
//
//  Created by nju on 16/6/5.
//  Copyright © 2016年 nju. All rights reserved.
//

import UIKit
import SpriteKit

class startViewController: UIViewController {
    lazy var sound = soundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sound.BackgroundMusic()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var skView : SKView = self.view as! SKView
        if (skView.scene == nil){
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            var scene : SKScene = startGameScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
