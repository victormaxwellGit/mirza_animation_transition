//
//  AttackState.swift
//  mirza_animation_transition
//
//  Created by Victor Maxwell on 07/10/19.
//  Copyright © 2019 VictorMaxwell. All rights reserved.
//

import Foundation
import GameplayKit

class AttackState:GKState{
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if(stateClass is IdleState.Type || stateClass is RunState.Type){
            return true
        }
        return false
    }
    
}
