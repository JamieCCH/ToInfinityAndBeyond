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
    var isGameStart = false
    var counter = 0
    var counterTimer = Timer()
    var counterStartVal = 3
    
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
    
    lazy var countdownLabel:SKLabelNode = {
        var label = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        label.text = "3"
        label.fontSize = 80
        label.fontColor = UIColor.white
        label.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        label.zPosition = NodesZPosition.ui.rawValue
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        return label
    }()
    
    func startCounter(){
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func timerCountDown(){
        if !isGameStart{
            if counter <= 1{
                isGameStart = true
            }
            
            counter -= 1
            let sec = counter % 60
            countdownLabel.text = "\(sec)"
            
            let scaleUp = SKAction.scale(to: 5.5, duration: 0.25)
            let fadeIn = SKAction.fadeIn(withDuration: 0.25)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.25)
            let fadeOut = SKAction.fadeOut(withDuration: 0.25)
            let inGroup = SKAction.group([fadeIn,scaleUp])
            let outGroup = SKAction.group([scaleDown,fadeOut])
            countdownLabel.run(SKAction.sequence([inGroup,outGroup]))
            
            if counter == 0{
                countdownLabel.text = "GO"
                let goAinm = SKAction.group([fadeIn, scaleUp])
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                countdownLabel.run(SKAction.sequence([goAinm,fadeOut]))
            }
        }
    }
}
