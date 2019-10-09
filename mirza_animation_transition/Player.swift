//
//  Player.swift
//  Mirzah Warrior
//
//  Created by Abner Matos on 25/09/19.
//  Copyright © 2019 Abner Matos. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class Player: SCNNode{
    
    //nodes
    var model       : SCNNode!
    var stateMachine: GKStateMachine?
    override init() {
        super.init()
        
        setupPlayer()
        setupAnimation()
        setMachineToPlayer()
        idle()
    }
    
    func setMachineToPlayer(){
        
        
        stateMachine = GKStateMachine(states: [IdleState(),JumpState(),DeadState(),RunState(),AttackState(),PowerAttackState()])
        stateMachine?.enter(IdleState.self)
    }
    
    func lightAttackStop(){
        self.childNode(withName: "mirza", recursively: true)!.animationPlayer(forKey: "attack")?.stop(withBlendOutDuration: 0.1)
    }
    func lightAttack(){
        
        if(stateMachine?.enter(AttackState.self) ?? false){
            self.childNode(withName: "mirza", recursively: true)!.animationPlayer(forKey: "attack")?.play()
        }
    }
    
    func idle(){
        model.animationPlayer(forKey: "idle")?.play()
    }
    func run(){
        if(stateMachine?.enter(RunState.self) ?? false){
            print("Correndo")
           self.childNode(withName: "mirza", recursively: true)!.animationPlayer(forKey: "run")?.play()
        }
    }
    func kick(){
        self.childNode(withName: "mirza", recursively: true)!.animationPlayer(forKey: "kick")?.play()
    }
    func kickStop(){
          self.childNode(withName: "mirza", recursively: true)!.animationPlayer(forKey: "kick")?.stop(withBlendOutDuration: 0.1)
    }
 
    
    func setupPlayer(){
        
        name = "Player"
        let scene = SCNScene(named: "art.scnassets/mirza/mirza.scn")!
        model = scene.rootNode.childNode(withName: "mirza", recursively: true)!
        position = SCNVector3Make(0.0, 0.0, 0.0)
        scale = SCNVector3Make(0.3, 0.3, 0.3)
        addChildNode(model)
    }
    
    func setupAnimation(){
        
        //################# IDLE ANIMATION ######################
        let idleAnimation = Player.loadAnimation(fromSceneNamed: "art.scnassets/mirza/idle.scn")
        idleAnimation.play()
        
        model.animationPlayer(forKey: "idle")?.play()
        model.addAnimationPlayer(idleAnimation, forKey: "idle")
        
        //################# RUN ANIMATION ######################
        
        let runAnimation = Player.loadAnimation(fromSceneNamed: "art.scnassets/mirza/run.scn")
        runAnimation.animation.blendInDuration = 0.2
        
        model.addAnimationPlayer(runAnimation, forKey: "run")
        runAnimation.stop()
        
        //################# ATTACK ANIMATION ######################
        
        let attackAnimation = Player.loadAnimation(fromSceneNamed: "art.scnassets/mirza/attack.scn")
        attackAnimation.animation.blendInDuration = 0.2
        attackAnimation.animation.animationEvents = [SCNAnimationEvent(keyTime: 1, block: {_,_,_ in
            
            self.setIdleInPlayer()})]
        
        model.addAnimationPlayer(attackAnimation, forKey: "attack")
        attackAnimation.stop(withBlendOutDuration: 0.2)
       
        
        //################# KICK ANIMATION #################
        
        let kickAnimation = Player.loadAnimation(fromSceneNamed: "art.scnassets/mirza/kick.scn")
        kickAnimation.animation.blendInDuration = 0.2
        kickAnimation.animation.animationEvents = [SCNAnimationEvent(keyTime: 1, block: {_,_,_ in
            
            self.setIdleInPlayer()})]
        
        model.addAnimationPlayer(kickAnimation, forKey: "kick")
        attackAnimation.stop()
        
        //################# DEAD ANIMATION ######################
        
    }
    func setIdleInPlayer(){
        lightAttackStop()
        kickStop()
        stateMachine?.enter(IdleState.self)
    }
    
    class func loadAnimation(fromSceneNamed sceneName: String) -> SCNAnimationPlayer {
        let scene = SCNScene( named: sceneName )!
       
        // find top level animation
        
        var animationPlayer: SCNAnimationPlayer! = nil
        scene.rootNode.enumerateChildNodes { (child, stop) in
            if !child.animationKeys.isEmpty {
                animationPlayer = child.animationPlayer(forKey: child.animationKeys[0])
                stop.pointee = true
            }
        }
        return animationPlayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // DPad
    
    var directionAngle: SCNFloat = 0.0{
        didSet{
            if directionAngle != oldValue{
                let action = SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true)
                runAction(action)
            }
        }
    }
    
    let speed: Float = 0.1
    
    func walkInDirection(_ direction: SIMD3<Float>){
        let currentPosition = SIMD3<Float>(position)
        position = SCNVector3(currentPosition + direction * speed)
    }
    
    
    //DPad Fim
    
}
