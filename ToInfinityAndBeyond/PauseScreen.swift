//
//  PauseScreen.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

class PauseScreen{
    
    lazy var background:SKSpriteNode = {
        var rectangle = SKSpriteNode(color: UIColor.black, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        rectangle.alpha = 0.8
        rectangle.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        rectangle.zPosition = NodesZPosition.overlayBg.rawValue
        return rectangle
    }()
    
    lazy var title:SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Menlo-Bold")
        label.text = "Game Pause"
        label.fontSize = 90
        label.fontColor = UIColor.white
        label.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - label.frame.height * 1.7)
        label.zPosition = NodesZPosition.overlayBg.rawValue
        label.horizontalAlignmentMode = .center
        return label
    }()
    
    lazy var backButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_back")
        sprite.name = "BackButton"
        sprite.setScale(0.4)
        sprite.position = CGPoint(x: UIScreen.main.bounds.midX, y: title.position.y - title.frame.height * 1.5)
        sprite.zPosition = NodesZPosition.overlayBg.rawValue
        return sprite
    }()
    
    lazy var restartButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_play_again")
        sprite.name = "RestartButton"
        sprite.setScale(0.4)
        sprite.position = CGPoint(x: UIScreen.main.bounds.midX, y: backButton.position.y - backButton.frame.height * 1.5)
        sprite.zPosition = NodesZPosition.overlayBg.rawValue
        return sprite
    }()

}
