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
    private var idleFrames: [SKTexture] = []
    private var runningFrames: [SKTexture] = []
    private var jumpFrames: [SKTexture] = []
    private var slideFrames: [SKTexture] = []
    private var fallFrames: [SKTexture] = []
    
    init() {
        robotSprite = SKSpriteNode()
        robotSprite.name = "Robot"
        buildIdleAnimation()
        buildSlideAnimation()
        buildJumpAnimation()
        buildFallAnimation()
        buildRunAnimation()
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
    
    private func buildFallAnimation(){
        let robotFallAtlas = SKTextureAtlas(named: "robotFall")
        let numImages = robotFallAtlas.textureNames.count - 1
        for i in 0...numImages {
            let robotFallName = "dead_\(i)"
            fallFrames.append(robotFallAtlas.textureNamed(robotFallName))
        }
        let firstFrameTexture = fallFrames[0]
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
        robotSprite.run(action, withKey:"\(action)")
    }
    
    func idle(){
        let idle = SKAction.animate(with: idleFrames, timePerFrame:0.2, resize: true, restore: true)
        robotSprite.run(SKAction.repeatForever(idle),withKey:"Idle")
    }
    
    func waitAndRun(){
        let wait = SKAction.wait(forDuration: 3.0)
        let runAnim = SKAction.animate(with: runningFrames, timePerFrame:0.1, resize: true, restore: true)
        let repeatRun = SKAction.repeatForever(runAnim)
        robotSprite.run(SKAction.sequence([wait,  repeatRun]), withKey:"waitAndRun")
    }
    
    func run(){
        let runAnim = SKAction.animate(with: runningFrames, timePerFrame:0.07, resize: true, restore: true)
        robotSprite.run(SKAction.repeatForever(runAnim), withKey:"Run")
    }
    
    func jump(){
        let beginJump = SKAction.run{isGrounded = false}
        let jump = SKAction.animate(with: jumpFrames, timePerFrame:0.05, resize: true, restore: true)
        let up = SKAction.moveBy(x: 0, y: robotSprite.frame.height, duration: 0.02)
        let jumpGroup = SKAction.group([beginJump,jump,up])
        let down = SKAction.moveBy(x: 0, y: -robotSprite.frame.height, duration: 0.01)
        let endJump = SKAction.run{isGrounded = true}
        robotSprite.run(SKAction.sequence([jumpGroup,down,endJump]), withKey: "Jump")
    }
    
    func slide(){
        let beginSlide = SKAction.run{isSlideing = true}
        let down = SKAction.moveBy(x: 0, y: -20, duration: 0.06)
        let slide = SKAction.animate(with: slideFrames, timePerFrame:0.06, resize: true, restore: true)
        let slideGroup = SKAction.group([beginSlide,down,slide])
        let moveBack = SKAction.moveBy(x: 0, y: 20, duration: 0.01)
        let endSlide = SKAction.run{isSlideing = false}
        robotSprite.run(SKAction.sequence([slideGroup,moveBack, endSlide]))
        //robotSprite.run(slide,withKey:"Slide")
    }
    
    func fall(){
        let fall = SKAction.animate(with: fallFrames, timePerFrame:0.2, resize: true, restore: true)
        robotSprite.run(fall,withKey:"Fall")
    }
    
}
