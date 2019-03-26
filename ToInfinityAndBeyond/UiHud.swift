//
//  UiHud.swift
//  ToInfinityAndBeyond
//
//  Created by Jamie on 2019/3/25.
//  Copyright © 2019 Jamie. All rights reserved.
//

import Foundation
import SpriteKit

public class UiHud{
    
    var coinColleted:Int = 345
    
    lazy var background:SKSpriteNode = {
        for i in 0 ... 1 {
            var sprite = SKSpriteNode(imageNamed: "background_city")
            sprite.size =  UIScreen.main.bounds.size
            sprite.name = "gameBg"
            sprite.anchorPoint = CGPoint.zero
            sprite.position = CGPoint(x: (sprite.frame.size.width * CGFloat(i)) - CGFloat(1 * i), y: 0.0)
            sprite.zPosition = NodesZPosition.background.rawValue
            return sprite
        }
        return self.background
    }()
    
    lazy var pauseButton:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "button_pause")
        sprite.name = "PauseButton"
        sprite.setScale(0.5)
        sprite.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        sprite.position = CGPoint(x: UIScreen.main.bounds.width - sprite.size.width/2, y: UIScreen.main.bounds.height - sprite.size.height/2)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var coinIcon:SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Coin")
        sprite.name = "CoinIcon"
        sprite.setScale(0.2)
        sprite.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        sprite.position = CGPoint(x: sprite.frame.size.width/2, y: UIScreen.main.bounds.height - sprite.frame.size.height/2)
        sprite.zPosition = NodesZPosition.ui.rawValue
        return sprite
    }()
    
    lazy var coinLabel:SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Menlo-Bold")
        label.text = "\(coinColleted)"
        label.fontSize = 35
        label.fontColor = UIColor.white
        label.position = CGPoint(x: self.coinIcon.frame.size.width*1.6, y: UIScreen.main.bounds.height - label.frame.size.height*2)
        label.zPosition = NodesZPosition.ui.rawValue
        label.horizontalAlignmentMode = .left
        return label
    }()
    
}
