//
//  GameScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import SpriteKit
import GameplayKit


var isGrounded = true;
var isSlideing = false;

class GameScene: SKScene {
    
    var ui = UiHud()
    var robot = Robot()
    var pauseView = PauseScreen()
    
    var gameBackground = SKSpriteNode()
    var BGM = SKAudioNode()
    var coin = SKSpriteNode()
    var rock = SKSpriteNode()
    var floats = SKSpriteNode()
    
    var maxNumCoin = 15
    var maxNumRock = 3
    var farestOutRight = 850
    var numRock = 0
    var numCoin = 0
    
    private var moveAmtX: CGFloat = 0
    private var moveAmtY: CGFloat = 0
    private let minimum_detect_distance: CGFloat = 100
    private var initialPosition: CGPoint = CGPoint.zero
    private var initialTouch: CGPoint = CGPoint.zero
    
    override init(size: CGSize) {super.init(size: size)}
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func addBGM(){
        BGM = SKAudioNode(fileNamed: "AllGoodInTheWood.mp3")
        addChild(BGM)
        let pause = SKAction.pause()
        let wait = SKAction.wait(forDuration: 1.8)
        let play = SKAction.play()
        BGM.run(SKAction.sequence([pause,wait,play]))
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "TIAB_ground")
        for i in 0 ... 1 {
            gameBackground = SKSpriteNode(texture: backgroundTexture)
            gameBackground.anchorPoint = CGPoint.zero
            gameBackground.position = CGPoint(x: self.frame.width * CGFloat(i), y: 0.0)
            gameBackground.name = "gameBg"
            gameBackground.size =  self.frame.size
            gameBackground.zPosition = NodesZPosition.background.rawValue
            addChild(gameBackground)
        }
    }
    
    func createCoin(){
        
        numCoin = Int.random(in: 3...maxNumCoin)
        let lowestY = self.frame.height/4
        let randomY = CGFloat.random(in: lowestY...lowestY*3)
        
        for i in 1 ... numCoin{
            coin = SKSpriteNode(imageNamed: "Coin")
            coin.name = "coin"
            coin.setScale(0.2)
            coin.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            let gap = coin.frame.width;
            coin.position = CGPoint(x: self.frame.width + CGFloat(i)*gap, y: randomY)
            coin.zPosition = NodesZPosition.actors.rawValue
            addChild(coin)
        }
    }
    
    func createRock(){
        let randomGap = CGFloat.random(in: 350...CGFloat(farestOutRight))
        numRock = Int.random(in: 1...maxNumRock)
        for i in 1...numRock{
            rock = SKSpriteNode(imageNamed: "TIAB_Rock1")
            rock.name = "rock"
            rock.setScale(0.4)
            rock.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            rock.position = CGPoint(x: self.frame.width + CGFloat(i)*randomGap, y: rock.frame.height*1.5)
            rock.zPosition = NodesZPosition.actors.rawValue
            addChild(rock)
        }
    }
    
    func moveBackround(){
        enumerateChildNodes(withName: "gameBg") { (gameBackground, run) in
            let wait = SKAction.wait(forDuration: 3.0)
            let moveLeft = SKAction.moveBy(x: -gameBackground.frame.width, y: 0, duration: 3.5)
            let moveReset = SKAction.moveBy(x: gameBackground.frame.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            let bgAnim = SKAction.sequence([wait,moveForever])
            gameBackground.run(bgAnim,withKey:"moveBg")
        }
    }
    
    func moveCoin(){
        let randomSec = CGFloat.random(in:3.5...5)
        let edgePos = self.frame.width + CGFloat(numCoin) * coin.frame.width
        enumerateChildNodes(withName: "coin") { (coin, move) in
            let wait = SKAction.wait(forDuration: TimeInterval(randomSec))
            let moveLeft = SKAction.moveBy(x: -edgePos, y: 0, duration: 3.5)
            let coinMove = SKAction.sequence([wait,moveLeft])
            coin.run(coinMove, withKey: "moveCoin")
        }
    }
    
    func moveRock(){
        let randomSec = CGFloat.random(in:3...4)
        let edgePos = self.frame.width + CGFloat(farestOutRight*numRock)
        enumerateChildNodes(withName: "rock") { (rock, run) in
            let wait = SKAction.wait(forDuration: TimeInterval(randomSec))
            let moveLeft = SKAction.moveBy(x: -edgePos, y: 0, duration: 4.5)
            let rockAnim = SKAction.sequence([wait,moveLeft])
            rock.run(rockAnim,withKey:"moveRock")
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(ui.countdownLabel)
        addChild(ui.pauseButton)
        addChild(ui.coinIcon)
        addChild(ui.coinLabel)
        addChild(robot.robotSprite)
        robot.idle()
        createBackground()
        moveBackround()
        
        ui.counter = ui.counterStartVal
        ui.startCounter()
        robot.waitAndRun()
        
        addBGM()
        
        createRock()
        moveRock()
        createCoin()
        moveCoin()
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
    
    func puaseGame(){
        enumerateChildNodes(withName: "gameBg") { (gameBackground, pause) in
            gameBackground.isPaused = true;
        }
        enumerateChildNodes(withName: "coin") { (coin, pause) in
            coin.isPaused = true;
        }
        enumerateChildNodes(withName: "rock") { (rock, pause) in
            rock.isPaused = true;
        }
    }
    
    func resumeGame(){
        enumerateChildNodes(withName: "gameBg") { (gameBackground, resume) in
            gameBackground.isPaused = false;
        }
        enumerateChildNodes(withName: "coin") { (coin, resume) in
            coin.isPaused = false;
        }
        enumerateChildNodes(withName: "rock") { (rock, resume) in
            rock.isPaused = false;
        }
    }
    
    func displayPauseScreen(){
        addChild(pauseView.background)
        addChild(pauseView.title)
        addChild(pauseView.backButton)
        addChild(pauseView.restartButton)
        BGM.run(SKAction.pause())
        robot.idle()
        puaseGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if ui.isGameStart {
            
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
                    if let touch = touches.first{
                        initialTouch = touch.location(in: self.scene!.view)
                        moveAmtY = 0
                        moveAmtX = 0
                        initialPosition = touch.location(in: view)
                        print("initialPosition:  \(initialPosition)")
                    }
                }
                
                if touchedNode.name == "BackButton"{
                    pauseView.background.removeFromParent()
                    pauseView.title.removeFromParent()
                    pauseView.backButton.removeFromParent()
                    pauseView.restartButton.removeFromParent()
                    run(buttonSound)
                    robot.run()
                    resumeGame()
                    BGM.run(SKAction.play())
                }
                
                if touchedNode.name == "RestartButton" {
                    loadMenuScene()
                    run(buttonSound)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            let movingPoint: CGPoint = touch.location(in: self.scene!.view)
            moveAmtX = movingPoint.x - initialTouch.x
            moveAmtY = movingPoint.y - initialTouch.y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if ui.isGameStart{
            
            for t in touches {
                let location = t.location(in: self)
                let touchedNode = atPoint(location)
                
                if touchedNode.name == "gameBg"{
                    if moveAmtY == 0 && moveAmtY == 0 && isGrounded{
                        robot.jump()
                    }
                    var direction = ""
                    if abs(moveAmtX) > minimum_detect_distance {
                        //must be moving side to side
                        if moveAmtX < 0 {
                            direction = "left"
                        }
                        else {
                            direction = "right"
                        }
                    }
                    else if abs(moveAmtY) > minimum_detect_distance {
                        //must be moving up and down
                        if moveAmtY < 0 {
                            direction = "up"
                        }
                        else {
                            direction = "down"
                        }
                    }
                    print("direction: \(direction)")
                    
                    if direction == "down" && isGrounded && !isSlideing{
                        robot.slide()
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if ui.isGameStart {
            enumerateChildNodes(withName: "coin") { (coin, delete) in
                if coin.position.x<=0{
                    coin.removeFromParent()
                }
            }
            enumerateChildNodes(withName: "rock") { (rock, delete) in
                if rock.position.x<=0{
                    rock.removeFromParent()
                    print("remove Rock")
                }
            }
            
            if self.childNode(withName: "coin") == nil{
                print("no coins")
                createCoin()
                moveCoin()
            }
            
            if self.childNode(withName: "rock") == nil{
                print("no rock")
                createRock()
                moveRock()
            }
        }
    }
    
}
