//
//  GameOverScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var ui = UiHud()
    
    override init(size: CGSize) {super.init(size: size)}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")}
    
    lazy var background:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "i4_TIAB_SpaceBgDown")
        sprite.size = frame.size
        sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        sprite.position = CGPoint(x: 0.0, y: 0.0)
        sprite.zPosition = NodesZPosition.background.rawValue
        return sprite
    }()
    
    lazy var title:SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Menlo-Bold")
        label.text = "Game Over"
        label.fontSize = 90
        label.fontColor = UIColor.white
        label.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - label.frame.height * 1.7)
        label.zPosition = NodesZPosition.ui.rawValue
        label.horizontalAlignmentMode = .center
        return label
    }()
    
    lazy var coinIcon:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Coin")
        sprite.name = "CoinIcon"
        sprite.setScale(0.25)
//        sprite.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        sprite.position = CGPoint(x: self.frame.midX - sprite.frame.width, y: self.frame.midY)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var result:SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Menlo-Bold")
//        label.numberOfLines = 0
        label.text = "\(coinColleted)"
        label.fontSize = 40
        label.fontColor = UIColor.white
        label.position = CGPoint(x: self.frame.midX, y: coinIcon.position.y - coinIcon.frame.height/3)
        label.zPosition = NodesZPosition.ui.rawValue
        label.horizontalAlignmentMode = .left
        return label
    }()
    

    lazy var restartButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_play_again")
        sprite.name = "RestartButton"
        sprite.setScale(0.4)
        sprite.position = CGPoint(x: self.frame.midX, y: sprite.size.height * 1.3)
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
        addChild(restartButton)
        addChild(title)
        addChild(result)
        addChild(coinIcon)
        addBGM()
    }
    
    func loadMenuScene(){
        let transition = SKTransition.push(with: .down, duration: 2.0)
        let nextScene = MenuScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "RestartButton" {
                loadMenuScene()
                run(buttonSound)
            }
        }
    }
    
}
