//
//  SplashScreenScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

class SplashScreenScene:SKScene {
    
    private var timer = Timer()
    
    lazy var i4logo:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "ifourgames")
        sprite.setScale(0.2)
        sprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        return sprite
    }()
    
    private func setup() {
        addChild(i4logo)
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(loadMenuScene), userInfo: nil, repeats: true)
    }
    
    @objc private func loadMenuScene() {
        let scene = MenuScene(size: self.frame.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.5)
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        self.setup()
        self.startTimer()
    }
    
    deinit {
        self.timer.invalidate()
    }
    
}
