//
//  GameScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ui = UiHud()
    var robot = Robot()
    var pauseView = PauseScreen()
    var gameBackground = SKSpriteNode()
    
    override init(size: CGSize) {super.init(size: size)}
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background_city")
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: background.frame.width * CGFloat(i), y: 0.0)
            background.name = "gameBg"
            background.size =  UIScreen.main.bounds.size
            background.zPosition = NodesZPosition.background.rawValue
            addChild(background)
            
//            let moveLeft = SKAction.moveBy(x: -background.frame.width, y: 0, duration: 20)
//            let moveReset = SKAction.moveBy(x: background.frame.width, y: 0, duration: 0)
//            let moveLoop = SKAction.sequence([moveLeft, moveReset])
//            let moveForever = SKAction.repeatForever(moveLoop)
//            background.run(moveForever)
        }
    }
    
    func addBGM(){
        let BGM = SKAudioNode(fileNamed: "AllGoodInTheWood.mp3")
        addChild(BGM)
        BGM.run(SKAction.play())
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(ui.background)
        addChild(ui.pauseButton)
        addChild(ui.coinIcon)
        addChild(ui.coinLabel)
        addChild(robot.robotSprite)
        robot.idle()
//        createBackground()
        addBGM()
    }
    

    func moveBackground(){
        let moveLeft = SKAction.moveBy(x:-self.frame.width, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x:self.frame.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        ui.background.run(moveForever)
    }
    
    func loadGameOverScene(){
        let transition = SKTransition.fade(with: UIColor.white, duration: 2.0)
        let nextScene = GameOverScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    func loadMenuScene(){
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let nextScene = MenuScene(size: self.frame.size)
        view?.presentScene(nextScene, transition: transition)
    }
    
    func displayPauseScreen(){
        addChild(pauseView.background)
        addChild(pauseView.title)
        addChild(pauseView.backButton)
        addChild(pauseView.restartButton)
        robot.idle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "PauseButton" {
                displayPauseScreen()
                run(buttonSound)
            }
            if touchedNode == robot.robotSprite{
                loadGameOverScene()
                print("touch robot")
            }
            if touchedNode.name == "gameBg"{
                //it should be robot.jump() in real game
                robot.run()
//                moveBackground()
            }
            if touchedNode.name == "BackButton"{
                pauseView.background.removeFromParent()
                pauseView.title.removeFromParent()
                pauseView.backButton.removeFromParent()
                pauseView.restartButton.removeFromParent()
                run(buttonSound)
            }
            if touchedNode.name == "RestartButton" {
                loadMenuScene()
                run(buttonSound)
            }
        }
    }
}
