//
//  CreditScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import GameplayKit

class CreditScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var background:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "i4_TIAB_Credits")
        sprite.size = frame.size
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        sprite.position = CGPoint(x: 0.0, y: 0.0)
        sprite.zPosition = NodesZPosition.background.rawValue
        return sprite
    }()
    
    lazy var playButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "i4_TIAB_button_Start")
        sprite.name = "PlayButton"
        sprite.setScale(0.3)
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        sprite.position = CGPoint(x: self.frame.size.width - sprite.frame.size.width*2, y: sprite.size.height*2)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var backButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "i4_TIAB_button_Back")
        sprite.name = "BackButton"
        sprite.setScale(0.3)
        sprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        sprite.position = CGPoint(x: sprite.frame.size.width*2, y: sprite.size.height*2)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    func addBGM(){
        let BGM = SKAudioNode(fileNamed: "BeBop25.mp3")
        addChild(BGM)
        BGM.run(SKAction.play())
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(background)
        addChild(playButton)
        addChild(backButton)
        addBGM()
    }
    
    func loadGameScene(){
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.6)
        let nextScene = GameScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    func loadMenuScene(){
//        let transition = SKTransition.fade(with: UIColor.white, duration: 2.0)
        let transition = SKTransition.push(with: .right, duration: 2.0)
        let nextScene = MenuScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "PlayButton" {
                let shrink = SKAction.scale(to: 0.25, duration: 0.02)
                let enlarge = SKAction.scale(to: 0.3, duration: 0.02)
                touchedNode.run(SKAction.sequence([shrink, enlarge]))
                let wait = SKAction.wait(forDuration: 0.1)
                let loadScene = SKAction.run {self.loadGameScene()}
                run(buttonSound)
                run(SKAction.sequence([wait,loadScene]))
            }
            if touchedNode.name == "BackButton" {
                let shrink = SKAction.scale(to: 0.25, duration: 0.02)
                let enlarge = SKAction.scale(to: 0.3, duration: 0.02)
                touchedNode.run(SKAction.sequence([shrink, enlarge]))
                let wait = SKAction.wait(forDuration: 0.1)
                let loadScene = SKAction.run {self.loadMenuScene()}
                run(buttonSound)
                run(SKAction.sequence([wait,loadScene]))
            }
        }
    }
    
}
