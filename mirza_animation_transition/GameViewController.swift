//
//  GameViewController.swift
//  mirza_animation_transition
//
//  Created by Victor Maxwell on 03/10/19.
//  Copyright © 2019 VictorMaxwell. All rights reserved.
//


import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var gameView: GameView{
        return view as! GameView
    }
    

    var sceneMundo: SCNScene!
    let player = Player()
    var touch: UITouch?
    var direction = SIMD2<Float>(0, 0)
    let camera = CameraNode()
    var animation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneMundo = SCNScene()
        gameView.scene = sceneMundo
        let light = LightNode()
        let floor = FloorNode()
        
        sceneMundo.rootNode.addChildNode(light)
        sceneMundo.rootNode.addChildNode(floor)
        sceneMundo.rootNode.addChildNode(camera)
        sceneMundo.rootNode.addChildNode(player)
        
        gameView.delegate = self
        gameView.isPlaying = true
        
    }
    
}

extension GameViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        let touchLocation = (touch?.location(in: self.view))!
       
        
        
        if gameView.virtualBot(positionBotY: 230, positionBotX: 559).contains(touchLocation){

            print("botão pressionado")

            player.lightAttack()
            animation = false
        }
     
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if let touch = self.touch ,touches.contains(touch) {
            resetInteraction()
            player.childNode(withName: "mirza", recursively: true)!.animationPlayer(forKey: "run")?.stop(withBlendOutDuration: 0.2)
            animation = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
         if let touch = self.touch ,touches.contains(touch) {
                   resetInteraction()
            
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touch{

            let touchLocation = touch.location(in: self.view)
            if gameView.virtualDPad().contains(touchLocation){
                if animation == false{
                    player.run()
                    animation = true
                }

                
            let middleOfCircleX = gameView.virtualDPad().origin.x + 75
            let middleOfCircleY = gameView.virtualDPad().origin.y + 75

            let lengthOfX = Float(touchLocation.x - middleOfCircleX)
            let legthOfY = Float(touchLocation.y - middleOfCircleY)

            direction = SIMD2<Float>(x: lengthOfX, y: legthOfY)
            direction = normalize(direction)

            let degree = atan2(direction.x, direction.y)
            player.directionAngle = degree

        }

    }
}
    func resetInteraction() {
            touch = nil
            direction = SIMD2<Float>(x: 0.0, y: 0.0)
            
    }

}

extension GameViewController: SCNSceneRendererDelegate {
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    let directionInV3 = SIMD3<Float>(x: direction.x, y: 0, z: direction.y)
    player.walkInDirection(directionInV3)
    camera.position.x = player.presentation.position.x
    camera.position.z = player.presentation.position.z + CameraNode.offset
  }
}
