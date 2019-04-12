//
//  GameScene.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import SpriteKit
import GameplayKit

let wallCategory: UInt32 = 0x1 << 0
let robotCategory: UInt32 = 0x1 << 1
let coinCategory: UInt32 = 0x1 << 2
let rockCategory: UInt32 = 0x1 << 3
let floatsCategory: UInt32 = 0x1 << 4

var isGrounded = true
var isSlideing = false

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var ui = UiHud()
    var robot = Robot()
    var pauseView = PauseScreen()
    
    var gameBackground = SKSpriteNode()
    var BGM = SKAudioNode()
    var jumpSound = SKAction()
    var coinSound = SKAction()
    var collisionSound = SKAction()
    var gameOverSound = SKAction()
    var slideSound = SKAction()
    
    var coin = SKSpriteNode()
    var rock = SKSpriteNode()
    var floats = SKSpriteNode()
    
    var maxNumCoin = 15
    var maxNumRock = 5
    var maxNumFloat = 3
    var coinSpeed = 15
    var rockSpeed = 7
    var floatsSpeed = 7
    
    var isGamePaused = false
    var coinMove = false
    var rockMove = false
    var floatsMove = false
    
    private var moveAmtX: CGFloat = 0
    private var moveAmtY: CGFloat = 0
    private let minimum_detect_distance: CGFloat = 100
    private var initialPosition: CGPoint = CGPoint.zero
    private var initialTouch: CGPoint = CGPoint.zero
    
    override init(size: CGSize) {
        super.init(size: size)
        self.physicsWorld.contactDelegate = self
        coinColleted = 0
        ui.isGameStart = false
        isDown = false
        isSlideing = false
    }
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func addBGM(){
        BGM = SKAudioNode(fileNamed: "AllGoodInTheWood.mp3")
        let pause = SKAction.pause()
        let wait = SKAction.wait(forDuration: 1.8)
        let play = SKAction.play()
        BGM.run(SKAction.sequence([pause,wait,play]))
        addChild(BGM)
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
        let numCoin = Int.random(in: 3...maxNumCoin)
        let lowestY = self.frame.height/4.5
        let randomY = CGFloat.random(in: lowestY...lowestY*3)
        for i in 0 ... numCoin{
            coin = SKSpriteNode(imageNamed: "Coin")
            coin.name = "coin"
            coin.setScale(0.2)
            //coin.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            let gap = coin.frame.width;
            coin.position = CGPoint(x: self.frame.width + coin.frame.width/2 + CGFloat(i)*gap, y: randomY)
            coin.zPosition = NodesZPosition.actors.rawValue
            addChild(coin)
        }
    }
    
    func createRock(){
        let randRockGap = CGFloat.random(in: 600...850)
        let numRock = Int.random(in: 1...maxNumRock)
        for i in 0...numRock{
            rock = SKSpriteNode(imageNamed: "TIAB_Rock1")
            rock.name = "rock"
            rock.setScale(0.4)
            //rock.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            rock.position = CGPoint(x: self.frame.width + rock.frame.width/2 + CGFloat(i)*randRockGap, y: rock.frame.height)
            rock.zPosition = NodesZPosition.objects.rawValue
            addChild(rock)
        }
    }
    
    func createFloats(){
        let numFloat = Int.random(in: 1...maxNumFloat)
        let randFloatGap = CGFloat.random(in: 950...1150)
        for i in 0 ... numFloat{
            floats = SKSpriteNode(imageNamed: "TIAB_float")
            floats.name = "floats"
            floats.setScale(0.5)
//            floats.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            floats.position = CGPoint(x: self.frame.width + CGFloat(i)*randFloatGap + floats.frame.width/2, y:self.frame.height/2.7)
            floats.zPosition = NodesZPosition.objects.rawValue
            addChild(floats)
        }
    }
    
    func moveBackround(){
        enumerateChildNodes(withName: "gameBg") { (gameBackground, run) in
            let wait = SKAction.wait(forDuration: 3.1)
            let moveLeft = SKAction.moveBy(x: -gameBackground.frame.width, y: 0, duration: 2.5)
            let moveReset = SKAction.moveBy(x: gameBackground.frame.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            let bgAnim = SKAction.sequence([wait,moveForever])
            gameBackground.run(bgAnim,withKey:"moveBg")
        }
    }
    
    func moveCoin(){
        self.enumerateChildNodes(withName: "coin") { (node, moveCoin) in
            node.position.x -= CGFloat(self.coinSpeed)
            if node.position.x <= -node.frame.width{
                node.removeFromParent()
            }
        }
    }
    
    func moveRock(){
        self.enumerateChildNodes(withName: "rock") { (node, moveRock) in
            node.position.x -= CGFloat(self.rockSpeed)
            if node.position.x <= -node.frame.width{
                node.removeFromParent()
            }
        }
    }
    
    func moveFloat(){
        self.enumerateChildNodes(withName: "floats") { (node, moveFloats) in
            node.position.x -= CGFloat(self.floatsSpeed)
            if node.position.x <= -node.frame.width{
                node.removeFromParent()
            }
        }
    }
    
    func setCoinPhysics(){
        enumerateChildNodes(withName: "coin") { (node, physics) in
//            node.physicsBody = SKPhysicsBody(texture: (self.coin.texture)!, size: (self.coin.size))
            node.physicsBody = SKPhysicsBody(circleOfRadius: self.coin.frame.width/2)
//            node.physicsBody = SKPhysicsBody(rectangleOf: self.coin.size)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.categoryBitMask = coinCategory
            node.physicsBody?.contactTestBitMask = robotCategory | floatsCategory  | rockCategory
            node.physicsBody?.collisionBitMask = robotCategory
            node.physicsBody?.isDynamic = true
            node.physicsBody?.usesPreciseCollisionDetection = true
        }
    }
    
    func setRockPhysics(){
        enumerateChildNodes(withName: "rock") { (node, physics) in
            node.physicsBody = SKPhysicsBody(texture: (self.rock.texture)!, size: (self.rock.size))
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.categoryBitMask = rockCategory
            node.physicsBody?.contactTestBitMask = robotCategory | coinCategory
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.isDynamic = true
        }
    }
    
    func setFloatsPhysics(){
        enumerateChildNodes(withName: "floats") { (node, physics) in
//            node.physicsBody = SKPhysicsBody(texture: (self.floats.texture)!, size: (self.floats.size))
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.floats.frame.width*0.9, height: self.floats.frame.height*0.9),center: CGPoint(x:0.0,y:5.0))
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.mass = 0
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.linearDamping = 0
            node.physicsBody?.categoryBitMask = floatsCategory
            node.physicsBody?.contactTestBitMask = robotCategory | coinCategory
            node.physicsBody?.collisionBitMask =  0
            node.physicsBody?.isDynamic = true
        }
    }
    
    func setPhysics(){
        
        let wallRect = CGRect(x: 0, y: 25, width: self.frame.size.width, height: self.frame.size.height)
        let borderBody = SKPhysicsBody(edgeLoopFrom: wallRect)
        self.physicsBody =  borderBody
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        self.physicsBody?.categoryBitMask = wallCategory
        self.physicsBody?.contactTestBitMask = robotCategory
        self.physicsBody?.collisionBitMask = robotCategory
        
        robot.robotSprite.physicsBody = SKPhysicsBody(texture: (robot.robotSprite.texture)!, size: (robot.robotSprite.size))
        robot.robotSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.robot.robotSprite.frame.width*0.8, height: self.robot.robotSprite.frame.height*0.9))
        robot.robotSprite.physicsBody?.affectedByGravity = true
        robot.robotSprite.physicsBody?.mass = 1.5
        robot.robotSprite.physicsBody?.allowsRotation = false
        robot.robotSprite.physicsBody?.categoryBitMask = robotCategory
        robot.robotSprite.physicsBody?.contactTestBitMask = wallCategory | coinCategory | rockCategory | floatsCategory
        robot.robotSprite.physicsBody?.collisionBitMask =  wallCategory | coinCategory | rockCategory | floatsCategory
        robot.robotSprite.physicsBody?.isDynamic = true
//        robot.robotSprite.physicsBody?.usesPreciseCollisionDetection = true
        
        setCoinPhysics()
        setRockPhysics()
        setFloatsPhysics()
    }
    
    func addSounds(){
        jumpSound = SKAction.playSoundFileNamed("Jump01.mp3", waitForCompletion: false)
        coinSound = SKAction.playSoundFileNamed("Coin.wav", waitForCompletion: false)
        collisionSound = SKAction.playSoundFileNamed("phone-bump-3.wav", waitForCompletion: false)
        gameOverSound = SKAction.playSoundFileNamed("game-over.wav", waitForCompletion: false)
        slideSound = SKAction.playSoundFileNamed("Sliding.mp3", waitForCompletion: false)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        ui.counter = ui.counterStartVal
        ui.startCounter()
        
        addChild(ui.countdownLabel)
        addChild(ui.pauseButton)
        addChild(ui.coinIcon)
        addChild(ui.coinLabel)
        addChild(robot.robotSprite)
        createBackground()
        moveBackround()
        robot.idle()
        robot.waitAndRun()
        
        createRock()
        createCoin()
        createFloats()
        setPhysics()
        
        addBGM()
        addSounds()
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
    
    func gameOver(){
        //add play game over music + wait
        let wait = SKAction.wait(forDuration: 2.0)
        let goGameOver = SKAction.run(){self.loadGameOverScene()}
        self.run(SKAction.sequence([wait,goGameOver]))
    }
    
    func pauseGame(){
        isGamePaused = true
        BGM.run(SKAction.pause())
        enumerateChildNodes(withName: "gameBg") { (gameBackground, pause) in
            gameBackground.isPaused = true
        }
    }
    
    func resumeGame(){
        let wait = SKAction.wait(forDuration: 0.5)
        self.run(wait){self.isGamePaused = false}
        
        enumerateChildNodes(withName: "gameBg") { (gameBackground, resume) in
            gameBackground.isPaused = false;
        }
    }
    
    func displayPauseScreen(){
        addChild(pauseView.background)
        addChild(pauseView.title)
        addChild(pauseView.backButton)
        addChild(pauseView.restartButton)
        robot.idle()
        pauseGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if ui.isGameStart {
            
            for t in touches {
                let location = t.location(in: self)
                let touchedNode = atPoint(location)
                
                if touchedNode.name == "PauseButton" {
                    let shrink = SKAction.scale(to: 0.45, duration: 0.02)
                    let enlarge = SKAction.scale(to: 0.5, duration: 0.02)
                    touchedNode.run(SKAction.sequence([shrink, enlarge]))
                    let wait = SKAction.wait(forDuration: 0.1)
                    let loadScene = SKAction.run {self.displayPauseScreen()}
                    run(buttonSound)
                    run(SKAction.sequence([wait,loadScene]))
                }
                if touchedNode == robot.robotSprite{
//                    loadGameOverScene()
//                    print("touch robot")
                }
                if !isGamePaused{
                    if let touch = touches.first{
                        initialTouch = touch.location(in: self.scene!.view)
                        moveAmtY = 0
                        moveAmtX = 0
                        initialPosition = touch.location(in: view)
//                        print("initialPosition:  \(initialPosition)")
                    }
                }
                
                if touchedNode.name == "BackButton"{
                    let shrink = SKAction.scale(to: 0.3, duration: 0.03)
                    let enlarge = SKAction.scale(to: 0.4, duration: 0.03)
                    touchedNode.run(SKAction.sequence([shrink, enlarge]))
                    let wait = SKAction.wait(forDuration: 0.2)
                    let loadScene = SKAction.run {
                        self.pauseView.background.removeFromParent()
                        self.pauseView.title.removeFromParent()
                        self.pauseView.backButton.removeFromParent()
                        self.pauseView.restartButton.removeFromParent()
                    }
                    run(buttonSound)
                    run(SKAction.sequence([wait,loadScene]))
                    robot.run()
                    resumeGame()
                    BGM.run(SKAction.play())
                }
                
                if touchedNode.name == "RestartButton" {
                    let shrink = SKAction.scale(to: 0.3, duration: 0.02)
                    let enlarge = SKAction.scale(to: 0.4, duration: 0.02)
                    touchedNode.run(SKAction.sequence([shrink, enlarge]))
                    let wait = SKAction.wait(forDuration: 0.2)
                    let loadScene = SKAction.run {self.loadMenuScene()}
                    run(buttonSound)
                    run(SKAction.sequence([wait,loadScene]))
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
                if !isGamePaused && isGrounded{
                    
                    if (moveAmtY == 0 && moveAmtY == 0)  || moveAmtY < 0{
                        robot.jump()
                        robot.robotSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1100))
                        run(jumpSound)
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
                    print("slide      \(isSlideing)")
                    print("onGround   \(isGrounded)")
                    if direction == "down" && isGrounded && !isSlideing{
                        run(slideSound)
                        robot.slide()
                    }
                    
                }
        }
    }
    
    func getCoin(){
        coinColleted += 1
        ui.coinLabel.text = "\(coinColleted)"
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask{
        case robotCategory | wallCategory:
//            print("--hit ground--")
            isGrounded = true
            break
            
        case robotCategory | coinCategory:
            let coinNode = contact.bodyA.categoryBitMask == coinCategory ? contact.bodyA.node : contact.bodyB.node
            if coinNode == nil {return}
            run(coinSound)
            coinNode?.removeFromParent()
            if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
//                print("--hit coin--")
                getCoin()
            }
            break
            
        case robotCategory | rockCategory:
//            print("--hit rock--")
            run(collisionSound)
            robot.fall()
            pauseGame()
            gameOver()
            break
            
        case robotCategory | floatsCategory:
            let robotX = robot.robotSprite.position.x
            let robotY = robot.robotSprite.position.y - robot.robotSprite.frame.height/2
            let floatsX = floats.position.x - floats.frame.width/2
            let floatsY = floats.position.y - floats.frame.height/1.8
            if robotX < floatsX  && robotY < floatsY {
                run(collisionSound)
                robot.fall()
                pauseGame()
                gameOver()
            }else{
                isGrounded = true
            }
            break
            
        case coinCategory | floatsCategory:
            let coinNode = contact.bodyA.categoryBitMask == coinCategory ? contact.bodyA.node : contact.bodyB.node
            coinNode?.removeFromParent()
//            print("--hit-- floats + coins")
            break
            
        case coinCategory | rockCategory:
            let coinNode = contact.bodyA.categoryBitMask == coinCategory ? contact.bodyA.node : contact.bodyB.node
            coinNode?.removeFromParent()
            break
            
        default:
//             print("no collision")
            break
        }
    }

    override func update(_ currentTime: TimeInterval) {
        
        if ui.isGameStart {
            
            robot.robotSprite.position.x = self.frame.width/4
            
            if !isGamePaused {
                let coinRandomSec = CGFloat.random(in: 2...3.5)
                let coinWait = SKAction.wait(forDuration: TimeInterval(coinRandomSec))
                self.run(coinWait){self.coinMove=true}
                if(coinMove){moveCoin()}
                
                let rockRandomSec = CGFloat.random(in: 7.5...15.5)
                let rockWait = SKAction.wait(forDuration: TimeInterval(rockRandomSec))
                self.run(rockWait){self.rockMove=true}
                if(rockMove){moveRock()}
                
                let floatsRandomSec = CGFloat.random(in: 4.5...6.5)
                let floatsWait = SKAction.wait(forDuration: TimeInterval(floatsRandomSec))
                self.run(floatsWait){self.floatsMove=true}
                if(floatsMove){moveFloat()}
            }
        
            if self.childNode(withName: "coin") == nil{
//                print("no coins")
                createCoin()
                setCoinPhysics()
            }
            
            if self.childNode(withName: "rock") == nil{
//                print("no rock")
                createRock()
                setRockPhysics()
            }
            
            if self.childNode(withName: "floats") == nil{
//                print("no floats")
                createFloats()
                setFloatsPhysics()
            }
        }
    }
    
}
