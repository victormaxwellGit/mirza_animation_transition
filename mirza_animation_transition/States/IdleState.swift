//
//  IdleState.swift
//  mirza_animation_transition
//
//  Created by Victor Maxwell on 07/10/19.
//  Copyright © 2019 VictorMaxwell. All rights reserved.
//

import Foundation
import GameplayKit

class IdleState:GKState{
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if(stateClass is JumpState.Type || stateClass is DeadState.Type || stateClass is RunState.Type || stateClass is AttackState.Type || stateClass is PowerAttackState.Type) {return true}
        return false
    }
}
