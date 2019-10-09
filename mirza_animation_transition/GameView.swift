//
//  GameView.swift
//  basic-setup
//
//  Created by Victor Maxwell on 03/10/19.
//  Copyright © 2019 Martin Lasek. All rights reserved.
//

import SceneKit
import SpriteKit

final class GameView:SCNView{
    var btLightAttack:SKShapeNode?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup2DOverlayer()
        //loadSubViews()
    }
    
    func loadSubViews(){
        loadAttackButton()
    }
    
    func loadAttackButton(){
        
        let theme    = CGRect(x: 100, y: 100 , width: 300, height: 300)
        
        let button   = UIButton(frame: theme)
        button.tintColor = .white
        self.addSubview(button)
    }
    
    func setup2DOverlayer(){
        let viewHeigth = bounds.size.height
        let viewWidth = bounds.size.width
        
        let  sceneSize = CGSize(width: viewWidth, height: viewHeigth)
        let skScene = SKScene(size: sceneSize)
        
        skScene.scaleMode = .resizeFill
        
        let dpadShape = SKShapeNode(circleOfRadius: 75)
        dpadShape.strokeColor = .white
        dpadShape.lineWidth = 2.0
        
        dpadShape.position.x = dpadShape.frame.size.width / 2 + 10
        dpadShape.position.y = dpadShape.frame.size.height / 2 + 20
       
        let btAttack = botShapeControl(strokeColor: .red, fillColor: .red, lineWidth: 2.0, positionX: viewWidth + 145, positionY: 50)
        btLightAttack = btAttack
        let btJump = botShapeControl(strokeColor: .blue, fillColor: .blue, lineWidth: 2.0, positionX: viewWidth + 200, positionY: 120)
        
        skScene.addChild(dpadShape)
        skScene.addChild(btAttack)
        skScene.addChild(btJump)
        
        skScene.isUserInteractionEnabled = false
        
        overlaySKScene = skScene
    }
    
    func virtualDPad() -> CGRect{
        var vDPad = CGRect(x: 0, y: 0, width: 150, height: 150)
        vDPad.origin.y = bounds.size.height - vDPad.size.height - 10
        vDPad.origin.x = 10
        
        return vDPad
    }
    
    func virtualBot(positionBotY:CGFloat, positionBotX:CGFloat) -> CGRect{
        var vBot = CGRect(x: 0, y: 0, width: 60, height: 60)
        //let viewHeigth = bounds.size.height
        //let viewWidth = bounds.size.width
        
         vBot.origin.x = positionBotX
        vBot.origin.y =  positionBotY
       
        
        return vBot
        
    }
    
    func botShapeControl(strokeColor:UIColor, fillColor:UIColor, lineWidth:CGFloat, positionX:CGFloat, positionY:CGFloat) -> SKShapeNode{
        let botShape = SKShapeNode(circleOfRadius: 35)
//        let botShape = Button(circleOfRadius: 30)
        botShape.strokeColor = strokeColor
        botShape.fillColor = fillColor
        botShape.lineWidth = lineWidth
        botShape.position.x = positionX
        botShape.position.y = positionY
        
       // print (positionX, positionY)
        
        return botShape
    }
}
