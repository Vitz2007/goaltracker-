//
//  CelebrationManager.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/24.
//

import Foundation
import AVFoundation

@Observable
class CelebrationManager {
    static let shared = CelebrationManager()
    
    var isCelebrating = false
    // --- NEW PROPERTY ---
    // This will hold the goal that was just completed.
    var lastCompletedGoal: Goal?
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() { }
    
    // --- UPDATED FUNCTION ---
    // The start function now accepts the goal that was completed.
    func start(goal: Goal) {
        self.lastCompletedGoal = goal
        
        isCelebrating = false
        isCelebrating = true
        
        playSound()
    }
    
    private func playSound() {
        let systemSoundID: SystemSoundID = 1103
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
