//
//  MenuScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "PlanetsInSpace")
        background.size = frame.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        background.position = CGPoint(x: size.width / 2.0, y: 0.0)
        background.zPosition = -1
        addChild(background)
    }
    
    func addButton(){
        let playButton = SKSpriteNode(imageNamed: "button_startGame")
        playButton.name = "PlayButton"
        playButton.setScale(0.4)
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(playButton)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        addBackground()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func loadGameScene(){
        let transition = SKTransition.fade(with: UIColor.white, duration: 2.0)
        let nextScene = GameScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "PlayButton" {
                loadGameScene()
            }
        }
    }
}
