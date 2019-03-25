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
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(ui.background)
        addChild(ui.pauseButton)
        addChild(ui.coinIcon)
        addChild(ui.coinLabel)
        addChild(robot.robotSprite)
        robot.idle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "PauseButton" {
                //overlay pause screen
            }
        }
    }
}
