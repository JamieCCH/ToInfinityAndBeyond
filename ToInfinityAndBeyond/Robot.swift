//
//  Robot.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

public class Robot{
    
    var robotSprite:SKSpriteNode
    var idleFrames: [SKTexture] = []
    var runningFrames: [SKTexture] = []
    var jumpFrames: [SKTexture] = []
    var slideFrames: [SKTexture] = []
    
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    
    init() {
        robotSprite = SKSpriteNode()
        buildIdleAnimation()
        buildRunAnimation()
        buildSlideAnimation()
        buildJumpAnimation()
        x = robotSprite.position.x
        y = robotSprite.position.y
        self.setup()
    }
    
    private func setup(){
        robotSprite.zPosition = NodesZPosition.actors.rawValue
        robotSprite.setScale(0.25)
        robotSprite.position = CGPoint(x: UIScreen.main.bounds.width/4, y: robotSprite.frame.height/2 * 1.5)
    }
    
    private func buildIdleAnimation(){
        let robotIdleAtlas = SKTextureAtlas(named: "robotIdle")
        let numImages = robotIdleAtlas.textureNames.count - 1
        for i in 0...numImages {
            let robotIdleName = "idle_\(i)"
            idleFrames.append(robotIdleAtlas.textureNamed(robotIdleName))
        }
        let firstFrameTexture = idleFrames[0]
        robotSprite = SKSpriteNode(texture: firstFrameTexture)
    }
    
    private func buildRunAnimation() {
        let robotRunAtlas = SKTextureAtlas(named: "robotRun")
        let numImages = robotRunAtlas.textureNames.count - 1
        for i in 0...numImages {
            let runTextureName = "run_\(i)"
            runningFrames.append(robotRunAtlas.textureNamed(runTextureName))
        }
        let firstFrameTexture = runningFrames[0]
        robotSprite = SKSpriteNode(texture: firstFrameTexture)
    }
    
    private func buildSlideAnimation(){
        let robotSlideAtlas = SKTextureAtlas(named: "robotSlide")
        let numImages = robotSlideAtlas.textureNames.count - 1
        for i in 0...numImages{
            let slideTextureName = "slide_\(i)"
            slideFrames.append(robotSlideAtlas.textureNamed(slideTextureName))
        }
        let firstFrameTexture = slideFrames[0]
        robotSprite = SKSpriteNode(texture: firstFrameTexture)
    }
    
    private func buildJumpAnimation(){
        let robotJumpAtlas = SKTextureAtlas(named: "robotJump")
        let numImages = robotJumpAtlas.textureNames.count - 1
        for i in 0...numImages{
            let jumpTextureName = "jump_\(i)"
            jumpFrames.append(robotJumpAtlas.textureNamed(jumpTextureName))
        }
        let firstFrameTexture = jumpFrames[0]
        robotSprite = SKSpriteNode(texture: firstFrameTexture)
    }
    
    
    func runSingleAnimation(Action action:String, Frame texture:[SKTexture], TimePerFrame interval:Double, CanResize resize:Bool, CanRestore restore: Bool){
        let action = SKAction.animate(with: texture, timePerFrame:interval, resize: true, restore: true)
        robotSprite.run(action,withKey:"\(action)")
    }
    
    func idle(){
        let idle = SKAction.animate(with: idleFrames, timePerFrame:0.2, resize: true, restore: true)
        robotSprite.run(SKAction.repeatForever(idle),withKey:"Idle")
    }
    
    func run(){
        let run = SKAction.animate(with: runningFrames, timePerFrame:0.2, resize: true, restore: true)
        robotSprite.run(SKAction.repeatForever(run),withKey:"Run")
    }
    
    func jump(){
        let jump = SKAction.animate(with: jumpFrames, timePerFrame:0.2, resize: true, restore: true)
        robotSprite.run(jump,withKey:"Jump")
    }
    
    func slide(){
        let slide = SKAction.animate(with: slideFrames, timePerFrame:0.2, resize: true, restore: true)
        robotSprite.run(slide,withKey:"Slide")
    }
    
    
}
