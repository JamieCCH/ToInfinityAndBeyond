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
    
    //TODO: - Add label here to indicate game over
    //TODO: - Add button to restart to menu
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = frame.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        background.position = CGPoint(x: size.width / 2.0, y: 0.0)
        background.zPosition = -1
        addChild(background)
    }
    
    func addButton(){
        let restartButton = SKSpriteNode(imageNamed: "button_play_again")
        restartButton.name = "RestartButton"
        restartButton.setScale(0.5)
        restartButton.position = CGPoint(x: self.frame.midX, y: self.frame.size.height/3)
        addChild(restartButton)
    }
    
    func addLabel(){
        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 80
        label.fontColor = UIColor.white
        label.position = CGPoint(x: self.frame.midX, y: self.frame.size.height/2)
        addChild(label)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        addBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addButton()
        addLabel()
    }
    
    func loadMenuScene(){
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
        let nextScene = MenuScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "RestartButton" {
                loadMenuScene()
            }
        }
    }
    
}
