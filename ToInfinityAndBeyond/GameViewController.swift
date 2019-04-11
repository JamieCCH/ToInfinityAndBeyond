//
//  GameViewController.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var splashScreen: SplashScreenScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        
//        skView.showsFPS = true
//        skView.showsPhysics = true
        
        
        splashScreen = SplashScreenScene(size: skView.bounds.size)
        splashScreen.scaleMode = .aspectFit
        
        let game = MenuScene(size: skView.bounds.size)
        game.scaleMode = .aspectFit
        
        skView.presentScene(splashScreen)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
