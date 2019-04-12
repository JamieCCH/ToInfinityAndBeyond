//
//  MenuScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

var buttonSound = SKAction.playSoundFileNamed("button.wav", waitForCompletion: false)

class MenuScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var background:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "i4_TIAB_SpaceBgUp")
        sprite.size = frame.size
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        sprite.position = CGPoint(x: 0.0, y: 0.0)
        sprite.zPosition = NodesZPosition.background.rawValue
        return sprite
    }()

    lazy var playButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_startGame")
        sprite.name = "PlayButton"
        sprite.setScale(0.3)
        sprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        sprite.position = CGPoint(x: self.frame.midX - sprite.frame.width/2 , y: self.frame.midY + sprite.size.height/1.5)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var creditButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_credit")
        sprite.name = "CreditButton"
        sprite.setScale(0.3)
        sprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        sprite.position = CGPoint(x: self.frame.midX - sprite.frame.width/2, y: self.frame.midY - sprite.size.height/1.5)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var gameLogo:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "i4_TIAB_logo")
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        sprite.setScale(0.35)
        sprite.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
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
        addChild(creditButton)
        addChild(gameLogo)
        addBGM()
    }

    func loadGameScene(){
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.6)
        let nextScene = GameScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    func loadCreditScene(){
        let transition = SKTransition.push(with: .left, duration: 2.0)
//        let transition = SKTransition.fade(with: UIColor.white, duration: 2.0)
        let nextScene = CreditScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "PlayButton" {
                loadGameScene()
                run(buttonSound)
            }
            if touchedNode.name == "CreditButton" {
                loadCreditScene()
                run(buttonSound)
            }
        }
    }
}
