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
        var sprite = SKSpriteNode(imageNamed: "background_credit")
        sprite.size = frame.size
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        sprite.position = CGPoint(x: 0.0, y: 0.0)
        sprite.zPosition = NodesZPosition.background.rawValue
        return sprite
    }()
    
    lazy var playButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_startGame")
        sprite.name = "PlayButton"
        sprite.setScale(0.4)
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        sprite.position = CGPoint(x: self.frame.size.width/3 * 2, y: self.frame.midY + sprite.size.height)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var backButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_back")
        sprite.name = "BackButton"
        sprite.setScale(0.4)
        sprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        sprite.position = CGPoint(x: self.frame.size.width/3, y: self.frame.midY + sprite.size.height)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(background)
        addChild(playButton)
        addChild(backButton)
    }
    
    func loadGameScene(){
        let transition = SKTransition.fade(with: UIColor.white, duration: 2.0)
        let nextScene = GameScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    func loadMenuScene(){
        let transition = SKTransition.fade(with: UIColor.white, duration: 2.0)
        let nextScene = MenuScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "PlayButton" {
                loadGameScene()
            }
            if touchedNode.name == "BackButton" {
                loadMenuScene()
            }
        }
    }
    
    
}
